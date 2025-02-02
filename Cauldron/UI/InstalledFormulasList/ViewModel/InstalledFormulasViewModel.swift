import Foundation
import SwiftUI

@MainActor
@Observable class InstalledFormulasViewModel {
    private(set) var formulas: [String] = []
    private(set) var error: String?
    private(set) var isLoading = false
    
    private let useCase: ListInstalledFormulasUseCaseProtocol
    
    init(useCase: ListInstalledFormulasUseCaseProtocol = ListInstalledFormulasUseCase()) {
        self.useCase = useCase
    }
    
    func fetchInstalledFormulas() async {
        isLoading = true
        error = .none
        
        do {
            formulas = [try await useCase.execute()]
        } catch {
            self.error = error.localizedDescription
        }
        
        isLoading = false
    }
}
