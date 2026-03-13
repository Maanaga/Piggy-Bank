//
//  ChildInfoNetworkService.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

struct ChildInfoResponse: Decodable {
    let id: Int
    let iban: String
    let balance: Int
    let points: Int
    let name: String
    let surname: String
    let role: Int
    let piggyBanks: [PiggyBankDTO]?
}

final class ChildInfoNetworkService {
    private let networkService: NetworkService

    init(networkService: NetworkService = AppEnvironment.networkService) {
        self.networkService = networkService
    }

    func getChildInfo(childId: Int) async throws -> ChildInfoResponse {
        try await networkService.get(
            "api/User/\(childId)/child-Info",
            as: ChildInfoResponse.self
        )
    }
}
