//
//  CreateNewGoalCheckpointField.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalCheckpointFieldLabel: View {
    let title: String

    var body: some View {
        Text(title)
            .font(FontType.regular.fontType(size: 14))
            .foregroundStyle(.secondary)
    }
}

struct CreateNewGoalCheckpointTextField: View {
    @Binding var value: String
    var hasError: Bool = false

    var body: some View {
        HStack {
            TextField("0", text: $value)
                .keyboardType(.decimalPad)
                .font(FontType.regular.fontType(size: 17))
                .foregroundStyle(.primary)
            Spacer(minLength: 8)
            Text("₾")
                .font(FontType.regular.fontType(size: 15))
                .foregroundStyle(.secondary)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 12)
        .background(Color(.white))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(hasError ? Color.red : Color(.systemGray4), lineWidth: hasError ? 1.5 : 1)
        )
    }
}
