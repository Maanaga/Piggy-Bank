//
//  AddMoneyHeaderView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyHeaderView: View {
    let goalTitle: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Add Money")
                .font(FontType.bold.fontType(size: 28))
                .foregroundStyle(.primary)
            Text("to \(goalTitle)")
                .font(FontType.regular.fontType(size: 16))
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
        .background(Color(.systemBackground))
    }
}
