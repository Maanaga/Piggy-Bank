//
//  CreateNewGoalSheet.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CheckpointRow: Identifiable {
    let id = UUID()
    var amount: String
    var parentContribution: String
}

struct CreateNewGoalSheet: View {
    let childName: String
    let onDismiss: () -> Void

    @State private var step = 1
    @State private var goalName = ""
    @State private var selectedIconIndex = 0
    @State private var goalAmount = ""
    @State private var checkpoints: [CheckpointRow] = [CheckpointRow(amount: "0", parentContribution: "0")]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CreateNewGoalHeaderView(childName: childName)
                CreateNewGoalStepIndicatorView(currentStep: step)
                stepContent
                Spacer(minLength: 0)
                CreateNewGoalBottomButtonsView(
                    step: step,
                    onNext: { step = 2 },
                    onBack: { step = 1 },
                    onCreateGoal: { onDismiss() }
                )
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        onDismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(FontType.medium.fontType(size: 16))
                            .foregroundStyle(.primary)
                    }
                }
            }
        }
    }

    @ViewBuilder
    private var stepContent: some View {
        ScrollView {
            if step == 1 {
                CreateNewGoalStep1View(
                    goalName: $goalName,
                    selectedIconIndex: $selectedIconIndex,
                    goalAmount: $goalAmount
                )
            } else {
                CreateNewGoalStep2View(
                    checkpoints: $checkpoints,
                    onAddCheckpoint: {
                        checkpoints.append(CheckpointRow(amount: "0", parentContribution: "0"))
                    }
                )
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    CreateNewGoalSheet(childName: "Sophie Anderson", onDismiss: {})
}
