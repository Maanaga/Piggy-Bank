//
//  AddMoneyContinueButton.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyContinueButton: View {
    let canContinue: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text("Continue")
                .font(FontType.bold.fontType(size: 18))
                .foregroundStyle(canContinue ? .white : .secondary)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(canContinue ? Color("primaryBlue") : Color(.systemGray5))
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .disabled(!canContinue)
        .padding(.top, 8)
    }
}
