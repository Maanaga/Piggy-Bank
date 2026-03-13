//
//  CreateNewGoalSheet.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import SwiftUI

struct CreateNewGoalSheet: View {
    @ObservedObject var viewModel: MyChildrenViewModel

    private var childName: String {
        viewModel.selectedChild?.name ?? ""
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                CreateNewGoalHeaderView(childName: childName)
                CreateNewGoalStepIndicatorView(currentStep: viewModel.step)
                stepContent
                if let error = viewModel.createGoalError {
                    Text(error)
                        .font(FontType.regular.fontType(size: 14))
                        .foregroundStyle(.red)
                        .padding(.horizontal, 20)
                        .padding(.top, 8)
                }
                Spacer(minLength: 0)
                CreateNewGoalBottomButtonsView(
                    step: viewModel.step,
                    isCreatingGoal: viewModel.isCreatingGoal,
                    onNext: { viewModel.validateAndGoToStep2() },
                    onBack: { viewModel.goBackToStep1() },
                    onCreateGoal: { viewModel.validateAndCreateGoal() }
                )
            }
            .background(Color(.systemGroupedBackground))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        viewModel.dismissCreateGoalSheet()
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
            if viewModel.step == 1 {
                CreateNewGoalStep1View(
                    goalName: $viewModel.goalName,
                    selectedIconIndex: $viewModel.selectedIconIndex,
                    goalAmount: $viewModel.goalAmount,
                    errors: viewModel.step1Errors
                )
            } else {
                CreateNewGoalStep2View(
                    checkpoints: $viewModel.checkpoints,
                    errors: viewModel.step2Errors,
                    onAddCheckpoint: { viewModel.addCheckpoint() }
                )
            }
        }
        .padding(.top, 16)
    }
}

#Preview {
    let vm = MyChildrenViewModel(children: [
        Children(name: "Sophie Anderson", role: .children, avatarEmoji: "👧", balance: 125.50, iban: "GE00XXXX4532")
    ])
    vm.selectChild(vm.children[0])
    return CreateNewGoalSheet(viewModel: vm)
}
