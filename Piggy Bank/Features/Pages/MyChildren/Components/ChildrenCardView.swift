//
//  ChildrenCardView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildrenCardView: View {
    let name: String
    let avatarEmoji: String
    let balance: Decimal
    let iban: String
    var notificationCount: Int? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                ZStack {
                    Circle()
                        .fill(Color("primaryBlue"))
                        .frame(width: 48, height: 48)
                    Text(avatarEmoji)
                        .font(FontType.regular.fontType(size: 24))
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text(name)
                        .font(FontType.bold.fontType(size: 16))
                        .foregroundStyle(.primary)
                }

                Spacer()

                if let count = notificationCount, count > 0 {
                    ZStack {
                        Circle()
                            .fill(Color("primaryOrange"))
                            .frame(width: 24, height: 24)
                        Text("\(count)")
                            .font(FontType.bold.fontType(size: 12))
                            .foregroundStyle(.white)
                    }
                }
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Card Balance")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.secondary)
                HStack(alignment: .firstTextBaseline) {
                    Text(formatBalance(balance))
                        .font(FontType.bold.fontType(size: 22))
                        .foregroundStyle(.primary)
                    Text("₾")
                        .font(FontType.bold.fontType(size: 18))
                        .foregroundStyle(.secondary)
                    Spacer()
                    Text(iban)
                        .font(FontType.regular.fontType(size: 14))
                        .foregroundStyle(.secondary)
                }
            }

            HStack {
                Text("View Details")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(Color("primaryBlue"))
                Spacer()
                Image(systemName: "chevron.right")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(Color("primaryBlue"))
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

    private func formatBalance(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "0.00"
    }
}
