import Foundation
import SwiftSyntax

public struct SwiftFileReader {

  /// - Parameter filePaths: A list of relative paths to Swift files
  public init(filePaths: [String]) {
    self.filePaths = filePaths
  }

  private let filePaths: [String]

  public func run() -> [LineCount] {
    filePaths.map { LineCount(numberOfLines: 1, relativePath: $0) }
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
