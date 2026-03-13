//
//  PiggyBanksNetworkService.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

struct CreatePiggyBankCheckpointRequest: Encodable {
    let level: Int
    let targetAmount: Int
    let amountPrize: Int
    let rewardPoints: Int
}

struct CreatePiggyBankRequest: Encodable {
    let title: String
    let targetAmount: Int
    let bonusOnReach: Int?
    let iconUrl: String?
    let childId: Int
    let parentId: Int
    let endDate: String
    let checkpoints: [CreatePiggyBankCheckpointRequest]
}

struct RedeemCheckpointRequest: Encodable {
    let piggyBankId: Int
    let checkpointId: Int
}

final class PiggyBanksNetworkService {
    private let networkService: NetworkService

    init(networkService: NetworkService = AppEnvironment.networkService) {
        self.networkService = networkService
    }

    func createPiggyBank(parentId: Int, childId: Int, title: String, targetAmount: Int, bonusOnReach: Int?, iconUrl: String?, endDate: Date, checkpoints: [(targetAmount: Int, amountPrize: Int)]) async throws -> Int {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let endDateString = formatter.string(from: endDate)

        let checkpointRequests = checkpoints.enumerated().map { index, cp in
            CreatePiggyBankCheckpointRequest(
                level: index + 1,
                targetAmount: cp.targetAmount,
                amountPrize: cp.amountPrize,
                rewardPoints: cp.targetAmount
            )
        }

        let request = CreatePiggyBankRequest(
            title: title,
            targetAmount: targetAmount,
            bonusOnReach: bonusOnReach,
            iconUrl: iconUrl ?? "",
            childId: childId,
            parentId: parentId,
            endDate: endDateString,
            checkpoints: checkpointRequests
        )

        let response: Int = try await networkService.post(
            "api/PiggyBanks/parent/create",
            body: request,
            as: Int.self
        )
        return response
    }

    func redeemCheckpoint(piggyBankId: Int, checkpointId: Int) async throws {
        let request = RedeemCheckpointRequest(
            piggyBankId: piggyBankId,
            checkpointId: checkpointId
        )
        try await networkService.post(
            "api/PiggyBanks/checkpoint/redeem",
            body: request
        )
    }
}
