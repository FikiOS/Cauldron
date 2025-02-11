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
     let command = ListInstalledFormulasCommand()
     let response: ListInstalledResponse = try await service.execute(command)

     return response.formulae.map { Formulae(name: $0.name, fullName: $0.fullName, linkedKeg: $0.linkedKeg ?? "--") }
  }
}
