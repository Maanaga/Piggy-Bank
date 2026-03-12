//
//  BankCardView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct BankCardView: View {
    let cardTitle: String
    let balance: Decimal
    let cardLastFour: String

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 6) {
                Image(systemName: "creditcard.fill")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(.white)
                Text(cardTitle)
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(.white)
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Current Balance")
                    .font(FontType.regular.fontType(size: 12))
                    .foregroundStyle(.white.opacity(0.9))
                HStack(alignment: .firstTextBaseline) {
                    Text(formatBalance(balance))
                        .font(FontType.bold.fontType(size: 28))
                        .foregroundStyle(.white)
                    Text("₾")
                        .font(FontType.bold.fontType(size: 20))
                        .foregroundStyle(.white.opacity(0.9))
                }
            }

            Text("**** \(cardLastFour)")
                .font(FontType.regular.fontType(size: 14))
                .foregroundStyle(.white.opacity(0.9))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(20)
        .background(Color(.secondaryBlue))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func formatBalance(_ value: Decimal) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        return formatter.string(from: value as NSDecimalNumber) ?? "0.00"
    }
}

#Preview {
    BankCardView(
        cardTitle: "TBC Card",
        balance: 125.50,
        cardLastFour: "4532"
    )
    .padding()
}
