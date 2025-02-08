//
//  ListOutdatedFormulaesUseCase.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

typealias OutdatedFormulaesAndCasks = (formulaes: [OutdatedFormulae], casks: [OutdatedCask])

protocol ListOutdatedFormulaesUseCaseProtocol {
  func outdatedFormulaesAndCasks() async throws -> OutdatedFormulaesAndCasks
}

struct ListOutdatedFormulaesUseCase: ListOutdatedFormulaesUseCaseProtocol {
  private let service: BrewServiceProtocol

  init(service: BrewServiceProtocol = BrewService()) {
    self.service = service
  }

  func outdatedFormulaesAndCasks() async throws -> OutdatedFormulaesAndCasks {
    let command = ListOutdatedFormulasCommand()
    let response: OutdatedFormulaesAndTasksResponse = try await service.execute(command)

    let formulaes = response.formulae.map { OutdatedFormulae(name: $0.name, installedVersions: $0.installedVersions, currentVersion: $0.currentVersion, pinned: $0.pinned, pinnedVersion: $0.pinnedVersion) }
    let casks = response.casks.map { OutdatedCask(name: $0.name, installedVersions: $0.installedVersions, currentVersion: $0.currentVersion) }

    return (formulaes, casks)
  }
}
