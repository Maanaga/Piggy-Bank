//
//  PiggyBankGoal.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

struct GoalCheckpoint: Identifiable {
    let checkpointId: Int
    let level: Int
    let targetAmount: Int
    let isReached: Bool
    let isApprovedByParent: Bool

    var id: Int { checkpointId }

    var isPendingApproval: Bool {
        isReached && !isApprovedByParent
    }
}

struct PiggyBankGoal: Identifiable {
    let id: UUID
    let piggyBankId: Int
    let title: String
    let iconName: String
    let goalAmount: Int
    let checkpointsTotal: Int
    var currentAmount: Int
    var checkpointsCompleted: Int
    var status: GoalStatus
    var checkpoints: [GoalCheckpoint] = []

    static func new(title: String, iconName: String, goalAmount: Int, checkpointsTotal: Int) -> PiggyBankGoal {
        PiggyBankGoal(
            id: UUID(),
            piggyBankId: 0,
            title: title,
            iconName: iconName,
            goalAmount: goalAmount,
            checkpointsTotal: checkpointsTotal,
            currentAmount: 0,
            checkpointsCompleted: 0,
            status: .active
        )
    }

    static func from(dto: PiggyBankDTO) -> PiggyBankGoal {
        let checkpoints = (dto.checkpoints ?? [])
            .sorted { $0.level < $1.level }
            .map {
                GoalCheckpoint(
                    checkpointId: $0.checkpointId,
                    level: $0.level,
                    targetAmount: $0.targetAmount,
                    isReached: $0.reachedAt != nil || dto.currentAmount >= $0.targetAmount,
                    isApprovedByParent: $0.isApprovedByParent
                )
            }
        let completed = checkpoints.filter(\.isApprovedByParent).count
        let total = checkpoints.count
        let hasPendingApproval = checkpoints.contains(where: \.isPendingApproval)
        let status: GoalStatus = hasPendingApproval ? .pending : (dto.isCompleted ? .completed : .active)
        let iconName = (dto.iconUrl?.trimmingCharacters(in: .whitespacesAndNewlines)).flatMap { $0.isEmpty ? nil : $0 } ?? "gift.fill"
        return PiggyBankGoal(
            id: UUID(),
            piggyBankId: dto.piggyBankId,
            title: dto.title,
            iconName: iconName,
            goalAmount: dto.targetAmount,
            checkpointsTotal: max(total, 1),
            currentAmount: dto.currentAmount,
            checkpointsCompleted: completed,
            status: status,
            checkpoints: checkpoints
        )
    }
}
