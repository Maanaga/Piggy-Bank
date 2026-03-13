//
//  AddMoneySourceCardView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneySourceCardView: View {
    let source: PaymentSource

    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: source.balance as NSDecimalNumber) ?? "0.00"
    }

    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.black)
                    .frame(width: 44, height: 44)
                Image(systemName: "creditcard")
                    .font(FontType.medium.fontType(size: 20))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(source.title)
                    .font(FontType.bold.fontType(size: 16))
                    .foregroundStyle(.primary)
                Text("**** \(source.lastFour)")
                    .font(FontType.regular.fontType(size: 14))
                    .foregroundStyle(.secondary)
            }

            Spacer()

            Text("\(formattedBalance)₾")
                .font(FontType.bold.fontType(size: 16))
                .foregroundStyle(.primary)
        }
        .padding(16)
        .background(Color(.systemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .stroke(Color.primary.opacity(0.1), lineWidth: 1)
        )
    }
}
