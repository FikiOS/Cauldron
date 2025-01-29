import Foundation

protocol BrewServiceProtocol {
    func execute<T: Decodable>(_ command: BrewCommand) async throws -> T
}

enum BrewError: Error {
  case decodingError
  case brewNotFound
  case commandFailed(String)
}

actor BrewService: BrewServiceProtocol {
  private let brewPath = "/opt/homebrew/bin/brew" // /opt/homebrew/bin/brew"

  /*
  init() async throws {
    self.brewPath = try findBrewPath()
  }

  private func findBrewPath() throws -> String {
    // Find brew executable path
    let process = Process()
    let pipe = Pipe()

    process.executableURL = URL(fileURLWithPath: "/usr/bin/which")
    process.arguments = ["brew"]
    process.standardOutput = pipe

    try process.run()
    process.waitUntilExit()

    guard
      let path = String(data: pipe.fileHandleForReading.availableData,
                        encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines),
      !path.isEmpty else { throw BrewError.brewNotFound }

    return path
  } */

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
    try await withCheckedThrowingContinuation { continuation in
      let process = Process()
      let pipe = Pipe()

      // Configure process
      process.executableURL = URL(fileURLWithPath: brewPath)
      process.arguments = command.components(separatedBy: " ")
      process.standardOutput = pipe
      process.standardError = pipe

      let buffer = OutputBuffer()

      pipe.fileHandleForReading.readabilityHandler = { [buffer] fileHandle in
        let data = fileHandle.availableData
        print("Data1: \(String(data: data, encoding: .utf8) ?? "")")
        if !data.isEmpty {
          Task {
            print("Data2: \(String(data: data, encoding: .utf8) ?? "")")
            await buffer.append(data)
          }
        } else {
          print("Data 1 Empty")
        }
      }

      process.terminationHandler = { [buffer] process in
        pipe.fileHandleForReading.readabilityHandler = nil
        Task {
          if process.terminationStatus == 0 {
            continuation.resume(returning: await buffer.getData())
          } else {
            continuation.resume(throwing: BrewError.commandFailed("Command failed with status \(process.terminationStatus)"))
          }
        }
      }

      do {
        try process.run()
      } catch {
        continuation.resume(throwing: error)
      }
    }
  }
}
/*
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

    return pipe.fileHandleForReading.readDataToEndOfFile() */

actor OutputBuffer {
  private var data = Data()
  func append(_ newData: Data) {
    data.append(newData)
  }
  func getData() -> Data {
    data
  }
}
