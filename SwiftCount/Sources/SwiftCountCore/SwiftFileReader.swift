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
      return LineCount(numberOfLines: syntaxVisitor.lineCount, relativePath: $0.lastPathComponent)
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
  fileprivate let lineCount: Int = 1
}
