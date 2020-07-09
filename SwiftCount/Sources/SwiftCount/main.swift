import Foundation
import SwiftCountCore

struct StderrOutputStream: TextOutputStream {
  mutating func write(_ string: String) { fputs(string, stderr) }
}

var arguments = CommandLine.arguments
var standardError = StderrOutputStream()

guard arguments.count > 1 else {

  print("swiftcount Error: Need to pass at least one file path", to: &standardError)

  exit(1)
}

let filePaths: [String] = Array(arguments.dropFirst())

let swiftReader = SwiftFileReader(filePaths: filePaths)
do {
  let lineCount = try swiftReader.run()
  lineCount.forEach {
    print("\($0.numberOfLines) \($0.relativePath)")
  }
} catch {
  print("swiftcount Error: \(error)", to: &standardError)

  exit(1)
}
