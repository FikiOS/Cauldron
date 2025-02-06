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
  private enum Constants {
    static let brewPath = "/opt/homebrew/bin/brew"
  }

  let connection: NSXPCConnection

  init(connection: NSXPCConnection = NSXPCConnection(serviceName: "dag.fikios.ExecuteCommandService")) {
    self.connection = connection
  }


  func execute<T: Decodable>(_ command: BrewCommand) async throws -> T {
    defer { connection.invalidate() }

    connection.remoteObjectInterface = NSXPCInterface(with: ExecuteCommandServiceProtocol.self)
    connection.resume()

    guard let proxy = connection.remoteObjectProxy as? ExecuteCommandServiceProtocol else {
      throw BrewError.brewNotFound
    }

    let data = try await proxy.runCommand(path: Constants.brewPath, arguments: command.commandLine)

    return try JSONDecoder().decode(T.self, from: data)
  }
}
