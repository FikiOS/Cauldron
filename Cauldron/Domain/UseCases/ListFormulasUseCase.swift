//
//  ListFormulasUseCase.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import Foundation

protocol ListFormulasUseCaseProtocol {
  func formulas() async throws -> [Formula]
}

struct ListFormulasUseCase: ListFormulasUseCaseProtocol {
  private let service: BrewServiceProtocol

  init(service: BrewServiceProtocol = BrewService()) {
    self.service = service
  }

  func formulas() async throws -> [Formula] {
    let response: FormulasResponse = try await service.execute(FormulasCommand())

    return response.formulas.map { Formula(name: $0.name, description: $0.description, version: $0.versions.first?.stable ?? "-") }
  }
}
