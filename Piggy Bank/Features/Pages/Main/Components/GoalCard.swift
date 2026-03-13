//
//  GoalCard.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct GoalCard: View {
    let title: String
    let checkpointsCompleted: Int
    let checkpointsTotal: Int
    let status: GoalStatus
    let currentAmount: Int
    let goalAmount: Int
    let iconName: String
    let accentColor: Color
    let checkpoints: [GoalCheckpoint]

    init(
        title: String,
        checkpointsCompleted: Int,
        checkpointsTotal: Int,
        status: GoalStatus,
        currentAmount: Int,
        goalAmount: Int,
        iconName: String,
        accentColor: Color,
        checkpoints: [GoalCheckpoint] = []
    ) {
        self.title = title
        self.checkpointsCompleted = checkpointsCompleted
        self.checkpointsTotal = checkpointsTotal
        self.status = status
        self.currentAmount = currentAmount
        self.goalAmount = goalAmount
        self.iconName = iconName
        self.accentColor = accentColor
        self.checkpoints = checkpoints
    }

    private var progress: Double {
        guard goalAmount > 0 else { return 0 }
        return min(1, Double(currentAmount) / Double(goalAmount))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(accentColor)
                        .frame(width: 44, height: 44)
                    Image(systemName: iconName)
                        .font(FontType.medium.fontType(size: 20))
                        .foregroundStyle(.white)
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(FontType.bold.fontType(size: 16))
                        .foregroundStyle(.primary)
                    Text("\(checkpointsCompleted) of \(checkpointsTotal) checkpoints")
                        .font(FontType.regular.fontType(size: 12))
                        .foregroundStyle(.secondary)
                }

                Spacer()

                if case .pending = status {
                    HStack(spacing: 4) {
                        Image(systemName: "info.circle.fill")
                            .font(FontType.medium.fontType(size: 12))
                            .foregroundStyle(.white)
                        Text("Pending")
                            .font(FontType.medium.fontType(size: 12))
                            .foregroundStyle(.black)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(Color("primaryOrange"))
                    .clipShape(Capsule())
                }
            }

            HStack {
                Text("\(currentAmount) ₾")
                    .font(FontType.bold.fontType(size: 18))
                    .foregroundStyle(accentColor)
                Spacer()
            }

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(accentColor)
                .background(Color(.systemGray5))
                .scaleEffect(x: 1, y: 5, anchor: .center)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            HStack {
                CheckpointDotsView(
                    checkpoints: checkpoints,
                    completed: checkpointsCompleted,
                    total: checkpointsTotal,
                    accentColor: accentColor
                )
                Spacer()
                Text("Goal: \(goalAmount) ₾")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.secondary)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.15), lineWidth: 1)
        )
    }
}

// MARK: - Chekpoint dots view

struct CheckpointDotsView: View {
    let checkpoints: [GoalCheckpoint]
    let completed: Int
    let total: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 6) {
            if checkpoints.isEmpty {
                legacyDots
            } else {
                ForEach(checkpoints) { checkpoint in
                    checkpointCircle(for: checkpoint)
                }
            }
        }
    }

    @ViewBuilder
    private var legacyDots: some View {
        ForEach(0..<total, id: \.self) { index in
            if index < completed {
                completedCircle
            } else if index == completed {
                pendingCircle
            } else {
                lockedCircle
            }
        }
    }

    @ViewBuilder
    private func checkpointCircle(for checkpoint: GoalCheckpoint) -> some View {
        if checkpoint.isApprovedByParent {
            completedCircle
        } else if checkpoint.isPendingApproval {
            pendingCircle
        } else {
            lockedCircle
        }
    }

    private var completedCircle: some View {
        ZStack {
            Circle()
                .fill(accentColor)
                .frame(width: 24, height: 24)
            Image(systemName: "checkmark")
                .font(FontType.bold.fontType(size: 10))
                .foregroundStyle(.white)
        }
    }

    private var pendingCircle: some View {
        ZStack {
            Circle()
                .fill(Color("primaryOrange"))
                .frame(width: 24, height: 24)
            Image(systemName: "clock")
                .font(FontType.bold.fontType(size: 10))
                .foregroundStyle(.white)
        }
    }

    private var lockedCircle: some View {
        Circle()
            .stroke(Color(.systemGray5), lineWidth: 2)
            .background(Circle().fill(Color(.systemBackground)))
            .frame(width: 24, height: 24)
    }
}

enum GoalStatus {
    case active
    case pending
    case completed
}
