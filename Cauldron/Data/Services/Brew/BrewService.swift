import Foundation

protocol BrewServiceProtocol {
  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T
}

enum BrewError: Error {
  case decodingError
  case brewNotFound
  case commandFailed(String)
}

struct ShellResult {
  let output: String
  let error: String
  let status: Int32
}

enum ShellError: LocalizedError {
  case failedToStart(Error)
  case executionFailed(String)

  var errorDescription: String? {
    switch self {
    case .failedToStart(let error):
      return "Failed to start process: \(error.localizedDescription)"
    case .executionFailed(let message):
      return "Command failed: \(message)"
    }
  }
}

final class BrewService: BrewServiceProtocol {
  private let brewPath = "/opt/homebrew/bin/brew"

  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T {
    print("Executing command: \(command.commandLine)")

    return try await execute(brewPath, arguments: command.commandLine) as! T
  }

  private func executeWithStream(_ command: String, arguments: [String] = []) -> AsyncThrowingStream<String, Error> {
    AsyncThrowingStream { continuation in
      let process = Process()
      let pipe = Pipe()

      process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
      process.arguments = [command] + arguments
      process.standardOutput = pipe
      process.standardError = pipe

      let fileHandle = pipe.fileHandleForReading

      Task {
        do {
          try process.run()

          while true {
            let data = try fileHandle.read(upToCount: 1024)
            guard let data = data, !data.isEmpty else { break }

            if let output = String(data: data, encoding: .utf8) { continuation.yield(output) }
          }
          continuation.finish()
        } catch { continuation.finish(throwing: error) }
      }
    }
  }

  private func execute(_ command: String, arguments: [String] = []) async throws -> String {
    var output = String.empty
    for try await line in executeWithStream(command, arguments: arguments) {
      output.append(line)
      print(line)
    }
    return output
  }
}
