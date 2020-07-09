import Foundation
import SwiftSyntax

public struct SwiftFileReader {

  /// - Parameter filePaths: A list of relative paths to Swift files
  /// - Parameter parentPath: The path to the parent directory
  public init(
    filePaths: [String],
    parentPath: String = FileManager.default.currentDirectoryPath)
  {
    self.filePaths = filePaths
    self.parentPath = parentPath
  }

  private let filePaths: [String]
  private let parentPath: String

  public func run() throws -> [LineCount] {
    try filePaths.compactMap { filePath -> URL? in
      let parentURL = URL(fileURLWithPath: parentPath)
      return parentURL.appendingPathComponent(filePath)
    }.map {
      let syntaxVisitor = FileReaderSyntaxVisitor()
      let fileSyntax = try SyntaxParser.parse($0)
      syntaxVisitor.walk(fileSyntax)
      return LineCount(numberOfLines: syntaxVisitor.lineCounts - syntaxVisitor.commentCount, relativePath: $0.lastPathComponent)
    }
  }

  private func absolutePath(from relativePath: String) -> URL? {
    let currentDirectory = URL(string: FileManager.default.currentDirectoryPath)
    return URL(string: relativePath, relativeTo: currentDirectory)
  }
}

public struct LineCount: Equatable {
  public let numberOfLines: Int
  public let relativePath: String
}

private final class FileReaderSyntaxVisitor: SyntaxVisitor {
  fileprivate var commentCount: Int = 0
  fileprivate var lineCounts: Int = 0

  override func visit(_ token: TokenSyntax) -> SyntaxVisitorContinueKind {
    let extraComments = countComments(from: token.leadingTrivia) + countComments(from: token.trailingTrivia)
    let newLines = countNewLines(from: token.leadingTrivia) + countNewLines(from: token.trailingTrivia)

    commentCount += extraComments
    lineCounts += newLines

    if case .eof = token.tokenKind {
      lineCounts += 1
    }

    return .visitChildren
  }

  private func countComments(from trivia: Trivia) -> Int {
    return trivia.filter { triviaPiece in
      switch triviaPiece {
      case .lineComment, .blockComment, .docLineComment, .docBlockComment:
        return true
      default:
        return false
      }
    }.count
  }

  private func countNewLines(from trivia: Trivia) -> Int {
    return trivia.reduce(0) { sum, triviaPiece in
      switch triviaPiece {
      case .newlines(let count):
        return sum + count
      default:
        return sum
      }
    }

  }
}
