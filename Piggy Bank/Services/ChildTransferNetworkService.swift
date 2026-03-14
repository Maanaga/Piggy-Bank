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

    func parentToChildTransfer(
        parentId: Int,
        parentIBAN: String = "GE00MOCK00000000000000",
        childId: Int,
        childIBAN: String,
        amount: Double
    ) async throws {
        let queryItems: [URLQueryItem] = [
            URLQueryItem(name: "ParentId", value: "\(parentId)"),
            URLQueryItem(name: "ParentIBAN", value: parentIBAN),
            URLQueryItem(name: "ChildId", value: "\(childId)"),
            URLQueryItem(name: "ChildIBAN", value: childIBAN),
            URLQueryItem(name: "Amount", value: "\(amount)")
        ]
        try await networkService.post(
            "api/User/parent-to-child-transfer",
            queryItems: queryItems
        )
    }
}
