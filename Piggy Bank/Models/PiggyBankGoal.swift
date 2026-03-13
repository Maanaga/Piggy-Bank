//
//  PiggyBankGoal.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

struct PiggyBankGoal: Identifiable {
    let id: UUID
    let title: String
    let iconName: String
    let goalAmount: Int
    let checkpointsTotal: Int
    var currentAmount: Int
    var checkpointsCompleted: Int
    var status: GoalStatus

    static func new(title: String, iconName: String, goalAmount: Int, checkpointsTotal: Int) -> PiggyBankGoal {
        PiggyBankGoal(
            id: UUID(),
            title: title,
            iconName: iconName,
            goalAmount: goalAmount,
            checkpointsTotal: checkpointsTotal,
            currentAmount: 0,
            checkpointsCompleted: 0,
            status: .pending
        )
    }

    static func from(dto: PiggyBankDTO) -> PiggyBankGoal {
        let checkpoints = dto.checkpoints ?? []
        let completed = checkpoints.filter { $0.reachedAt != nil }.count
        let total = checkpoints.count
        let status: GoalStatus = dto.isCompleted ? .completed : .pending
        return PiggyBankGoal(
            id: UUID(),
            title: dto.title,
            iconName: "gift.fill",
            goalAmount: dto.targetAmount,
            checkpointsTotal: max(total, 1),
            currentAmount: dto.currentAmount,
            checkpointsCompleted: completed,
            status: status
        )
    }
}
