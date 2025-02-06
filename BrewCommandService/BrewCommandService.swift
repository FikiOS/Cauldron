//
//  BrewCommandService.swift
//  BrewCommandService
//
//  Created by David Alarcon on 6/2/25.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class BrewCommandService: NSObject, BrewCommandServiceProtocol {
  /// This implements the example protocol. Replace the body of this class with the implementation of this service's protocol.
  @objc func performCalculation(firstNumber: Int, secondNumber: Int, with reply: @escaping (Int) -> Void) {
    let response = firstNumber + secondNumber
    reply(response)
  }

//  func runBrewCommand(path: String, arguments: [String]) async throws -> String {
//    return try await withCheckedThrowingContinuation { continuation in
//      let process = Process()
//      let outputPipe = Pipe()
//
//      process.executableURL = URL(fileURLWithPath: path)
//      process.arguments = arguments
//      process.standardOutput = outputPipe
//
//      process.terminationHandler = { _ in
//        let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
//        if let output = String(data: outputData, encoding: .utf8) {
//          continuation.resume(returning: output)
//        } else {
//          continuation.resume(throwing: NSError(domain: "CommandError", code: 1, userInfo: nil))
//        }
//      }
//
//      do {
//        try process.run()
//      } catch {
//        continuation.resume(throwing: error)
//      }
//    }
//  }

  func runBrewCommand(path: String, arguments: [String]) async throws -> Data {
    return try await execute(path, arguments: arguments)
    /*
    return try await withCheckedThrowingContinuation { continuation in
      let process = Process()
      let outputPipe = Pipe()
      let errorPipe = Pipe() // Error pipe
      process.executableURL = URL(fileURLWithPath: path)
      process.arguments = arguments
      process.standardOutput = outputPipe
      process.standardError = errorPipe // Assign error pipe

      let commandData = CommandData() // Data

      let outputHandle = outputPipe.fileHandleForReading
      let errorHandle = errorPipe.fileHandleForReading // Error handle

      // Read standard output
      outputHandle.readabilityHandler = { [weak commandData] handle in
        guard let commandData = commandData else { return }

        let newData = handle.availableData
        if !newData.isEmpty {
          Task { await commandData.appendOutput(data: newData) }
        } else {
          outputHandle.readabilityHandler = nil // Stop reading
        }
      }

      // Read standard error
      errorHandle.readabilityHandler = { [weak commandData] handle in
        guard let commandData = commandData else { return }

        let newData = handle.availableData
        if !newData.isEmpty {
          Task { await commandData.appendError(data: newData) }
        } else {
          errorHandle.readabilityHandler = .none // Stop reading
        }
      }

      process.terminationHandler = { [weak commandData] _ in
        Task {
          guard let commandData = commandData else { return }

          do {
            // Extract the data from the actor *before* capturing it
            let output = try await commandData.getOutputString()
            let errorOutput = try await commandData.getErrorString()

            if !errorOutput.isEmpty {
              continuation.resume(throwing: CommandError.commandFailed(message: errorOutput))
            } else {
              continuation.resume(returning: output)
            }
          } catch {
            continuation.resume(throwing: error)
          }
        }
      }

      do {
        try process.run()
      } catch {
        continuation.resume(throwing: error)
      }
    }
     */
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

enum CommandError: Error {
  case outputDecodingFailed
  case errorDecodingFailed
  case commandFailed(message: String)
}

actor CommandData {
  var outputData = Data()
  var errorData = Data()

  func appendOutput(data: Data) {
    outputData.append(data)
  }

  func appendError(data: Data) {
    errorData.append(data)
  }

  func getOutputString() throws -> String {
    guard let output = String(data: outputData, encoding: .utf8) else {
      throw CommandError.outputDecodingFailed
    }
    return output
  }

  func getErrorString() throws -> String {
    guard let errorOutput = String(data: errorData, encoding: .utf8) else {
      throw CommandError.errorDecodingFailed
    }
    return errorOutput
  }
}
