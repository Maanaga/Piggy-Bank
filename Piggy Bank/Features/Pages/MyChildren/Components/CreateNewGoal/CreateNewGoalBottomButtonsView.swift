//
//  CreateNewGoalBottomButtonsView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalBottomButtonsView: View {
    let step: Int
    let onNext: () -> Void
    let onBack: () -> Void
    let onCreateGoal: () -> Void

    var body: some View {
        VStack(spacing: 12) {
            if step == 1 {
                Button(action: onNext) {
                    Text("Next: Add Checkpoints")
                        .font(FontType.medium.fontType(size: 16))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color("primaryBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                .buttonStyle(.plain)
            } else {
                HStack(spacing: 12) {
                    Button(action: onBack) {
                        Text("Back")
                            .font(FontType.medium.fontType(size: 16))
                            .foregroundStyle(.primary)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(Color(.systemBackground))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                    Button(action: onCreateGoal) {
                        HStack(spacing: 6) {
                            Image(systemName: "sparkles")
                                .font(FontType.medium.fontType(size: 14))
                            Text("Create Goal")
                                .font(FontType.medium.fontType(size: 16))
                        }
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(Color("primaryBlue"))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 32)
        .background(Color(.systemBackground))
    }
}
