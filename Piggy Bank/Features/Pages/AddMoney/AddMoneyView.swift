//
//  AddMoneyView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct AddMoneyView: View {
    @StateObject private var viewModel: AddMoneyViewModel
    var onBack: () -> Void
    var onContinue: (Int) -> Void

    init(goal: PiggyBankGoal, sources: [PaymentSource] = [], onBack: @escaping () -> Void, onContinue: @escaping (Int) -> Void) {
        _viewModel = StateObject(wrappedValue: AddMoneyViewModel(goal: goal, sources: sources))
        self.onBack = onBack
        self.onContinue = onContinue
    }

    var body: some View {
        VStack(spacing: 0) {
            AddMoneyHeaderView(goalTitle: viewModel.goal.title)
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    fromSection
                    toSection
                    AddMoneyAmountSectionView(viewModel: viewModel)
                    AddMoneyContinueButton(
                        canContinue: viewModel.canContinue,
                        action: {
                            viewModel.continueTapped()
                            onContinue(viewModel.displayAmount)
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

            AddMoneyGoalCardView(goal: viewModel.goal)
        }
    }
}

#Preview {
    NavigationStack {
        AddMoneyView(
            goal: PiggyBankGoal(
                id: UUID(),
                title: "New Bicycle",
                iconName: "bicycle",
                goalAmount: 250,
                checkpointsTotal: 6,
                currentAmount: 175,
                checkpointsCompleted: 4,
                status: .pending
            ),
            onBack: {},
            onContinue: { _ in }
        )
    }
}
