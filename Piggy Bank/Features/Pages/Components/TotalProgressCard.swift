//
//  TotalProgressCard.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct TotalProgressCard: View {
    let currentAmount: Int
    let targetAmount: Int

    private var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return min(1, Double(currentAmount) / Double(targetAmount))
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 6) {
                Image(systemName: "chart.line.uptrend.xyaxis")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Color("secondaryBlue"))
                Text("Total Progress")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(Color("secondaryBlue"))
            }

            HStack(alignment: .firstTextBaseline, spacing: 4) {
                Text("\(currentAmount) ₾")
                    .font(FontType.bold.fontType(size: 28))
                    .foregroundStyle(Color("primaryBlue"))
                Text("of \(targetAmount) ₾")
                    .font(FontType.medium.fontType(size: 16))
                    .foregroundStyle(Color("secondaryBlue"))
            }

            ProgressView(value: progress)
                .progressViewStyle(.linear)
                .tint(Color("primaryBlue"))
                .background(Color(.systemGray5))
                .scaleEffect(x: 1, y: 1.5, anchor: .center)
                .clipShape(RoundedRectangle(cornerRadius: 4))
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }
}

#Preview {
    TotalProgressCard(currentAmount: 220, targetAmount: 330)
        .padding()
}
