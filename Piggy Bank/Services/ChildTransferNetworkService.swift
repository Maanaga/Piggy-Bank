import Foundation

final class ChildTransferNetworkService {
    private let networkService: NetworkService

    init(networkService: NetworkService = AppEnvironment.networkService) {
        self.networkService = networkService
    }

    func transferToPiggyBank(
        childId: Int,
        depositAmount: Double,
        iban: String,
        piggyBankId: Int
    ) async throws {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ChildId", value: "\(childId)"),
            URLQueryItem(name: "DepositAmount", value: "\(depositAmount)"),
            URLQueryItem(name: "IBAN", value: iban),
            URLQueryItem(name: "PiggyBankId", value: "\(piggyBankId)")
        ]
        try await networkService.post(
            "api/User/child-transfer-to-piggybank",
            queryItems: queryItems
        )
    }
}
