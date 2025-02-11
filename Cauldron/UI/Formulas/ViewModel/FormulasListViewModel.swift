//
//  FormulasListViewModel.swift
//  Cauldron
//
//  Created by David Alarcon on 8/2/25.
//

import Foundation

@Observable
final class FormulasListViewModel {
  private(set) var formulas: [Formula] = Array.empty
  private(set) var error: String?
  private(set) var isLoading = false

  private let useCase: ListFormulasUseCaseProtocol

  init(useCase: ListFormulasUseCaseProtocol = ListFormulasUseCase()) {
    self.useCase = useCase
  }

  @MainActor
  func fetchFormulas() async {
    isLoading = true
    error = .none

    do {
      formulas = try await useCase.formulas()
    } catch {
      self.error = error.localizedDescription
    }

    isLoading = false
  }
}
