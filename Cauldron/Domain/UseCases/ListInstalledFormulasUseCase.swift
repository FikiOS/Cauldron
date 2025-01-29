import Foundation

protocol ListInstalledFormulasUseCaseProtocol {
    func execute() async throws -> [String]
}

struct ListInstalledFormulasUseCase: ListInstalledFormulasUseCaseProtocol {
    private let service: BrewServiceProtocol
    
    init(service: BrewServiceProtocol = BrewService()) {
        self.service = service
    }
    
    func execute() async throws -> [String] {
        let command = ListInstalledFormulasCommand()
        let response: String = try await service.execute(command)
        
        return [] // response
    }
} 