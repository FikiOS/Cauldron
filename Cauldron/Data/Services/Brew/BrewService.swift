import Foundation

protocol BrewServiceProtocol {
  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T
}

enum BrewError: Error {
  case decodingError
  case brewNotFound
  case commandFailed(String)
}

final class BrewService: BrewServiceProtocol {
  private let brewPath = "/opt/homebrew/bin/brew"

  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T {
    print("Executing command: \(command.commandLine)")

    let data = try await execute(brewPath, arguments: command.commandLine)

    do {
      return try JSONDecoder().decode(T.self, from: data)
    } catch {
      throw BrewError.decodingError
    }
  }

  private func executeWithStream(_ command: String, arguments: [String] = []) -> AsyncThrowingStream<Data, Error> {
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

            continuation.yield(data)
          }
          continuation.finish()
        } catch { continuation.finish(throwing: error) }
      }
    }
  }

  private func execute(_ command: String, arguments: [String] = []) async throws -> Data {
    var output = Data()
    for try await data in executeWithStream(command, arguments: arguments) {
      output.append(data)
      print(String(data: data, encoding: .utf8))
    }

    return output
  }
}
