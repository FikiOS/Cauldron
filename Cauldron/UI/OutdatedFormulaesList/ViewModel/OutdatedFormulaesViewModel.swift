//
//  OutdatedFormulaesViewModel.swift
//  Cauldron
//
//  Created by David Alarcon on 7/2/25.
//

import Foundation

@Observable
final class OutdatedFormulaesViewModel {
  private(set) var formulaes: [OutdatedFormulae] = Array.empty
  private(set) var casks: [OutdatedCask] = Array.empty
  private(set) var error: String?
  private(set) var isLoading = false

  private let useCase: ListOutdatedFormulaesUseCaseProtocol

  init(useCase: ListOutdatedFormulaesUseCaseProtocol = ListOutdatedFormulaesUseCase()) {
    self.useCase = useCase
  }

  @MainActor
  func fetchOutdatedFormulaes() async {
    isLoading = true
    error = .none

    do {
      let formulaesAndCasks = try await useCase.outdatedFormulaesAndCasks()
      formulaes = formulaesAndCasks.formulaes
      casks = formulaesAndCasks.casks
    } catch {
      self.error = error.localizedDescription
    }

    isLoading = false
  }
}
