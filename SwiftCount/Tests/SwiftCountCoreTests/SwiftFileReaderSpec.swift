import XCTest
import SwiftCountCore
import Foundation

final class SwiftFileReaderTest: XCTestCase {
  
  func test_run_it_returns_the_filepath() throws {
    let subject = try setup(filename: "file", content: "struct Some {}")
    XCTAssertEqual(try subject.run().first?.relativePath, "file.swift")
  }

  func test_run_it_returns_correct_number_of_files() throws {
    let subject = try setup(content: "struct Some {}")
    XCTAssertEqual(try subject.run().count, 1)
  }

  func test_run_with_no_comments_it_returns_line_count() throws {
    let content =
    """
    import Foundation
    struct Some {
      let value: String
    }
    """
    let subject = try setup(content: content)
    XCTAssertEqual(try subject.run().first?.numberOfLines, 4)
  }

  func test_run_with_comments_it_returns_line_count() throws {
    let content =
    """
    // Some
    import Foundation
    // Another comment
    struct Some {
      let value: String
    }
    """
    let subject = try setup(content: content)
    XCTAssertEqual(try subject.run().first?.numberOfLines, 4)
  }

  func test_run_with_multilinecomments_it_returns_line_count() throws {
    let content =
    """
    /*
    Some
    multi
    line
    comment
    */
    import Foundation
    // Another comment
    struct Some {
      let value: String
    }
    """
    let subject = try setup(content: content)
    XCTAssertEqual(try subject.run().first?.numberOfLines, 4)
  }


  private func setup(filename: String = UUID().uuidString, content: String) throws -> SwiftFileReader {
    let parentPath = try Temporary.makeFolder()
    let file = try Temporary.makeFile(content: content, name: filename, atPath: parentPath.absoluteString)
    return SwiftFileReader(filePaths: [file.lastPathComponent], parentPath: parentPath.absoluteString)
  }
}
