//
//  AddMoneyView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyView: View {
    @StateObject private var viewModel: AddMoneyViewModel
    @State private var showConfirmTransfer = false
    var onBack: () -> Void
    var onContinue: (Int) -> Void

    init(goals: [PiggyBankGoal], sources: [PaymentSource] = [], childId: Int? = nil, iban: String? = nil, onBack: @escaping () -> Void, onContinue: @escaping (Int) -> Void) {
        _viewModel = StateObject(wrappedValue: AddMoneyViewModel(goals: goals, sources: sources, childId: childId, iban: iban))
        self.onBack = onBack
        self.onContinue = onContinue
    }

    private var fromText: String {
        guard let source = viewModel.sources.first else { return "" }
        return "\(source.title) \(source.iban)"
    }

    var body: some View {
        VStack(spacing: 0) {
            AddMoneyHeaderView(goalTitle: viewModel.selectedGoal.title)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    fromSection
                    toSection
                    AddMoneyAmountSectionView(viewModel: viewModel)
                    AddMoneyContinueButton(
                        canContinue: viewModel.canContinue,
                        action: {
                            viewModel.continueTapped()
                            showConfirmTransfer = true
                        }
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 20)
                .padding(.bottom, 100)
            }
        }
        .background(Color(.systemBackground))
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    onBack()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(FontType.medium.fontType(size: 18))
                        .foregroundStyle(.primary)
                }
            }
        }
        .overlay {
            if showConfirmTransfer {
                Color.black.opacity(0.4)
                    .ignoresSafeArea()
                    .onTapGesture { showConfirmTransfer = false }
                    .overlay {
                        ConfirmTransferView(
                            amount: viewModel.displayAmount,
                            fromText: fromText,
                            toText: viewModel.selectedGoal.title,
                            newBalance: viewModel.selectedGoal.currentAmount + viewModel.displayAmount,
                            errorMessage: viewModel.transferError,
                            isConfirming: viewModel.isTransferring,
                            onCancel: {
                                viewModel.transferError = nil
                                showConfirmTransfer = false
                            },
                            onConfirm: {
                                Task {
                                    await viewModel.confirmTransfer()
                                    await MainActor.run {
                                        if viewModel.transferError == nil {
                                            showConfirmTransfer = false
                                            onContinue(viewModel.displayAmount)
                                            onBack()
                                        }
                                    }
                                }
                            }
                        )
                    }
            }
        }
        .animation(.easeInOut(duration: 0.2), value: showConfirmTransfer)
    }

    private var fromSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("From")
                .font(FontType.medium.fontType(size: 14))
                .foregroundStyle(.secondary)

            if let source = viewModel.sources.first {
                AddMoneySourceCardView(source: source)
            }
        }
    }

    private var toSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("To")
                .font(FontType.medium.fontType(size: 14))
                .foregroundStyle(.secondary)

            if viewModel.goals.count == 1 {
                AddMoneyGoalCardView(goal: viewModel.selectedGoal)
            } else {
                VStack(spacing: 12) {
                    ForEach(viewModel.goals) { goal in
                        AddMoneyGoalCardView(
                            goal: goal,
                            isSelected: viewModel.selectedGoal.id == goal.id,
                            onTap: { viewModel.selectGoal(goal) }
                        )
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AddMoneyView(
            goals: [
                PiggyBankGoal(id: UUID(), piggyBankId: 1, title: "New Bicycle", iconName: "bicycle", goalAmount: 250, checkpointsTotal: 6, currentAmount: 175, checkpointsCompleted: 4, status: .pending),
                PiggyBankGoal(id: UUID(), piggyBankId: 2, title: "Camera", iconName: "camera", goalAmount: 1500, checkpointsTotal: 3, currentAmount: 0, checkpointsCompleted: 0, status: .pending)
            ],
            onBack: {},
            onContinue: { _ in }
        )
    }
}
