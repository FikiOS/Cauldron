//
//  ExecuteCommandService.swift
//  ExecuteCommandService
//
//  Created by David Alarcon on 6/2/25.
//

import Foundation

/// This object implements the protocol which we have defined. It provides the actual behavior for the service. It is 'exported' by the service to make it available to the process hosting the service over an NSXPCConnection.
class ExecuteCommandService: NSObject, ExecuteCommandServiceProtocol {
    
  func runCommand(path: String, arguments: [String]) async throws -> Data {
    var output = Data()
    for try await data in executeWithStream(path, arguments: arguments) { output.append(data) }

    return output
  }

  private func executeWithStream(_ command: String, arguments: [String] = []) -> AsyncThrowingStream<Data, Error> {
    AsyncThrowingStream { continuation in
      let process = Process()
      let pipe = Pipe()
      let errorPipe = Pipe()

      process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
      process.arguments = [command] + arguments
      process.standardOutput = pipe
      process.standardError = errorPipe

      let fileHandle = pipe.fileHandleForReading
      let errorFileHandle = errorPipe.fileHandleForReading

      fileHandle.readabilityHandler = { fileHandle in
        let data = fileHandle.availableData
        if !data.isEmpty { continuation.yield(data) }
      }

      errorFileHandle.readabilityHandler = { fileHandle in
        let data = fileHandle.availableData
        if !data.isEmpty { continuation.yield(data) }
      }

      process.terminationHandler = { _ in
        continuation.finish()
      }

      Task {
        do { try process.run() }
        catch { continuation.finish(throwing: error) }
      }
    }
  }
}
