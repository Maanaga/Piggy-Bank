//
//  CreateNewGoalStep2View.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalStep2View: View {
    @Binding var checkpoints: [CheckpointRow]
    let errors: Step2ValidationErrors
    let onAddCheckpoint: () -> Void

    private func checkpointError(at index: Int) -> (amount: String?, parentContribution: String?) {
        guard index < errors.checkpointErrors.count else { return (nil, nil) }
        return errors.checkpointErrors[index]
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack(alignment: .top, spacing: 8) {
                Image(systemName: "info.circle.fill")
                    .font(FontType.medium.fontType(size: 14))
                    .foregroundStyle(Color("primaryBlue"))
                Text("Set checkpoint milestones. When child reaches each amount, you'll contribute from your account.")
                    .font(FontType.regular.fontType(size: 14))
                    .foregroundStyle(Color("primaryBlue"))
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color("primaryBlue").opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: 10))

            ForEach(checkpoints.indices, id: \.self) { index in
                let err = checkpointError(at: index)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Checkpoint \(index + 1)")
                        .font(FontType.bold.fontType(size: 16))
                        .foregroundStyle(.primary)
                    VStack(alignment: .leading, spacing: 12) {
                        CreateNewGoalCheckpointFieldLabel(title: "Amount")
                        CreateNewGoalCheckpointTextField(value: $checkpoints[index].amount, hasError: err.amount != nil)
                        if let msg = err.amount {
                            Text(msg)
                                .font(FontType.regular.fontType(size: 12))
                                .foregroundStyle(.red)
                        }
                        CreateNewGoalCheckpointFieldLabel(title: "Parent Contribution")
                        CreateNewGoalCheckpointTextField(value: $checkpoints[index].parentContribution, hasError: err.parentContribution != nil)
                        if let msg = err.parentContribution {
                            Text(msg)
                                .font(FontType.regular.fontType(size: 12))
                                .foregroundStyle(.red)
                        }
                    }
                }
                .padding(16)
                .background(Color(.systemBackground))
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }

            Button(action: onAddCheckpoint) {
                HStack(spacing: 8) {
                    Image(systemName: "plus")
                        .font(FontType.medium.fontType(size: 16))
                    Text("Add Checkpoint")
                        .font(FontType.medium.fontType(size: 16))
                }
                .foregroundStyle(Color("primaryBlue"))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color("primaryBlue"), style: StrokeStyle(lineWidth: 2, dash: [6]))
                )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }
}

#Preview {
    CreateNewGoalStep2View(
        checkpoints: .constant([CheckpointRow(amount: "0", parentContribution: "0")]),
        errors: Step2ValidationErrors(),
        onAddCheckpoint: {}
    )
}
