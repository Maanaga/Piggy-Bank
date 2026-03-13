//
//  AddMoneyGoalCardView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyGoalCardView: View {
    let goal: PiggyBankGoal
    var isSelected: Bool = true
    var onTap: (() -> Void)?
    private let accentColor = Color("primaryBlue")

    var body: some View {
        let content = HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(accentColor.opacity(0.2))
                    .frame(width: 44, height: 44)
                Image(systemName: goal.iconName)
                    .font(FontType.medium.fontType(size: 20))
                    .foregroundStyle(accentColor)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(goal.title)
                    .font(FontType.bold.fontType(size: 16))
                    .foregroundStyle(.primary)
                Text("\(goal.currentAmount)₾ of \(goal.goalAmount)₾")
                    .font(FontType.regular.fontType(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 22))
                    .foregroundStyle(accentColor)
            }
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(isSelected ? accentColor : Color.clear, lineWidth: 2)
        )

        if let onTap = onTap {
            Button(action: onTap) { content }
                .buttonStyle(.plain)
        } else {
            content
        }
    }
}
