import Foundation
import SwiftUI

@Observable
final class InstalledFormulasViewModel {
  private(set) var formulaes: [Formulae] = []
  private(set) var error: String?
  private(set) var isLoading = false

  private let useCase: ListInstalledFormulaesUseCaseProtocol

  init(useCase: ListInstalledFormulaesUseCaseProtocol = ListInstalledFormulaesUseCase()) {
    self.useCase = useCase
  }

  @MainActor
  func fetchInstalledFormulaes() async {
    isLoading = true
    error = .none

    do {
      formulaes = try await useCase.installedFormulaesAndCasks()
    } catch {
      self.error = error.localizedDescription
    }

    isLoading = false
  }
}
