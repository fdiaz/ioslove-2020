import XCTest
import SwiftCountCore
import Foundation

final class SwiftFileReaderTest: XCTestCase {
  var subject: SwiftFileReader!

  override func setUp() {
    subject = SwiftFileReader(filePaths: [
      "some/file.swift",
      "some/another.swift",
    ])
  }

  func test_run_it_returns_the_filepath() {
    XCTAssertEqual(subject.run().first?.relativePath, "some/file.swift")
  }

  func test_run_it_returns_correct_number_of_files() {
    XCTAssertEqual(subject.run().count, 2)
  }

}
