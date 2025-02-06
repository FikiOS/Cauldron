import Foundation

protocol ListInstalledFormulaesUseCaseProtocol {
    func installedFormulaesAndCasks() async throws -> [Formulae]
}

struct ListInstalledFormulaesUseCase: ListInstalledFormulaesUseCaseProtocol {
  private let service: BrewServiceProtocol

  init(service: BrewServiceProtocol = BrewService()) {
    self.service = service
  }

  func installedFormulaesAndCasks() async throws -> [Formulae] {
    /*
     let command = ListInstalledFormulasCommand()
     let response: ListInstalledResponse = try await service.execute(command)

     return response.formulae.map { Formulae(name: $0.name, fullName: $0.fullName, linkedKeg: $0.linkedKeg ?? "--") }
     */
    let connection = NSXPCConnection(serviceName: "dag.fikios.BrewCommandService")
    connection.remoteObjectInterface = NSXPCInterface(with: BrewCommandServiceProtocol.self)
    connection.resume()

    guard let proxy = connection.remoteObjectProxy as? BrewCommandServiceProtocol else {
      throw BrewError.brewNotFound
    }

    let command = ListInstalledFormulasCommand()

    let data = try await proxy.runBrewCommand(path: "/opt/homebrew/bin/brew",
                                              arguments: command.commandLine)
    let response =  try JSONDecoder().decode(ListInstalledResponse.self, from: data)

    return response.formulae.map { Formulae(name: $0.name, fullName: $0.fullName, linkedKeg: $0.linkedKeg ?? "--") }
  }
}
