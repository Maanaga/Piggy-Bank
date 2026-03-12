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

    private var progress: Double {
        guard goalAmount > 0 else { return 0 }
        return min(1, Double(currentAmount) / Double(goalAmount))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(accentColor.opacity(0.25))
                        .frame(width: 44, height: 44)
                    Image(systemName: iconName)
                        .font(.system(size: 20, weight: .medium))
                        .foregroundStyle(accentColor)
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
                            .font(.system(size: 12))
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
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .clipShape(RoundedRectangle(cornerRadius: 4))

            HStack {
                CheckpointDotsView(
                    completed: checkpointsCompleted,
                    total: checkpointsTotal,
                    currentIndex: checkpointsCompleted,
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
    let completed: Int
    let total: Int
    let currentIndex: Int
    let accentColor: Color

    var body: some View {
        HStack(spacing: 6) {
            ForEach(0..<total, id: \.self) { index in
                if index < completed {
                    ZStack {
                        Circle()
                            .fill(accentColor)
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                } else if index == completed {
                    ZStack {
                        Circle()
                            .fill(Color("primaryOrange"))
                            .frame(width: 24, height: 24)
                        Image(systemName: "checkmark")
                            .font(.system(size: 10, weight: .bold))
                            .foregroundStyle(.white)
                    }
                } else {
                    Circle()
                        .stroke(Color(.systemGray5), lineWidth: 2)
                        .background(Circle().fill(Color(.systemBackground)))
                        .frame(width: 24, height: 24)
                }
            }
        }
    }
}

enum GoalStatus {
    case pending
    case completed
}
