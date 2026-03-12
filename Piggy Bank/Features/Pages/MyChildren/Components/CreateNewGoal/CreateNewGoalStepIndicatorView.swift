//
//  CreateNewGoalStepIndicatorView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalStepIndicatorView: View {
    let currentStep: Int

    var body: some View {
        HStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(Color("primaryBlue"))
                    .frame(width: 28, height: 28)
                Text("1")
                    .font(FontType.bold.fontType(size: 14))
                    .foregroundStyle(.white)
            }
            Rectangle()
                .fill(currentStep >= 2 ? Color("primaryBlue") : Color(.systemGray4))
                .frame(height: 2)
                .frame(maxWidth: .infinity)
            ZStack {
                Circle()
                    .fill(currentStep >= 2 ? Color("primaryBlue") : Color(.systemGray4))
                    .frame(width: 28, height: 28)
                Text("2")
                    .font(FontType.bold.fontType(size: 14))
                    .foregroundStyle(currentStep >= 2 ? .white : .secondary)
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 16)
        .background(Color(.systemBackground))
    }
}

#Preview {
    CreateNewGoalStepIndicatorView(currentStep: 1)
}
