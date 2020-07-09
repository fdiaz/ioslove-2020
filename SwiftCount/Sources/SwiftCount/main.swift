import Foundation
import SwiftCountCore

struct StderrOutputStream: TextOutputStream {
  mutating func write(_ string: String) { fputs(string, stderr) }
}

var arguments = CommandLine.arguments

guard arguments.count > 1 else {
  var standardError = StderrOutputStream()

  print("swiftcount Error: Need to pass at least one file path", to: &standardError)

  exit(1)
}

let filePaths: [String] = Array(arguments.dropFirst())

let swiftReader = SwiftFileReader(filePaths: filePaths)
let lineCount = swiftReader.run()

lineCount.forEach {
  print("\($0.numberOfLines) \($0.relativePath)")
}
