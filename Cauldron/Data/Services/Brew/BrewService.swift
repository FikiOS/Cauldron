import Foundation

protocol BrewServiceProtocol {
    func execute<T: Decodable>(_ command: BrewCommand) async throws -> T
}

enum BrewError: Error {
    case decodingError
    case commandFailed(String)
}

actor BrewService: BrewServiceProtocol {
  private let brewPath = "/opt/homebrew/bin/brew" // /opt/homebrew/bin/brew"

  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T {
    print("Executing command: \(command.commandLine)")
    let data = try await executeCommand(command.commandLine)

    do {
      let decoder = JSONDecoder()
      return try decoder.decode(T.self, from: data)
    } catch {
      throw BrewError.decodingError
    }
  }

  private func executeCommand(_ command: String) async throws -> Data {
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: brewPath)
    process.arguments = command.split(separator: " ").map { String($0) }
    process.standardOutput = pipe
    process.standardError = pipe

    do {
      try process.run()
      print("Process started successfully.")
    } catch {
      print("Failed to start process: \(error)")
      throw error
    }

    process.waitUntilExit()

    guard process.terminationStatus == 0 else {
      let errorData = pipe.fileHandleForReading.readDataToEndOfFile()
      let errorMessage = String(data: errorData, encoding: .utf8) ?? "Unknown error"
      throw BrewError.commandFailed(errorMessage)
    }

    return pipe.fileHandleForReading.readDataToEndOfFile()
  }
}
