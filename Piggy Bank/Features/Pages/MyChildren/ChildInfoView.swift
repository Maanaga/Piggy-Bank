//
//  ChildInfoView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildInfoView: View {
    @ObservedObject var viewModel: MyChildrenViewModel

    @State private var currentApproval: PendingCheckpointApproval?
    @State private var showApprovalError = false
    @State private var approvalErrorMessage = ""

    var body: some View {
        ZStack {
            if let child = viewModel.selectedChild {
                mainContent(child: child)
            } else {
                Color.clear
                    .onAppear { viewModel.onBack?() }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .navigationBarHidden(false)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    viewModel.onBack?()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(FontType.medium.fontType(size: 18))
                        .foregroundStyle(.primary)
                }
            }
        }
        .sheet(isPresented: $viewModel.showCreateGoalSheet) {
            CreateNewGoalSheet(viewModel: viewModel)
        }
        .onAppear {
            Task {
                await viewModel.refreshSelectedChildGoalsAndPendingApprovals()
                await MainActor.run {
                    currentApproval = viewModel.pendingCheckpointApprovals.first
                }
            }
        }
        .sheet(item: $currentApproval) { approval in
            CheckpointApprovalSheetView(
                approval: approval,
                isApproving: viewModel.isApprovingCheckpoint,
                onApprove: {
                    Task {
                        await viewModel.approvePendingCheckpoint(approval)
                        await MainActor.run {
                            if let error = viewModel.checkpointApprovalError {
                                currentApproval = nil
                                approvalErrorMessage = error
                                showApprovalError = true
                            } else {
                                currentApproval = viewModel.pendingCheckpointApprovals.first
                            }
                        }
                    }
                },
                onReject: {
                    viewModel.dismissPendingCheckpoint(approval)
                    currentApproval = nil
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                        currentApproval = viewModel.pendingCheckpointApprovals.first
                    }
                },
                onDismiss: {
                    currentApproval = nil
                }
            )
        }
        .alert("Checkpoint Approval Failed", isPresented: $showApprovalError) {
            Button("OK", role: .cancel) {
                viewModel.checkpointApprovalError = nil
            }
        } message: {
            Text(approvalErrorMessage)
        }
    }

    private func mainContent(child: Children) -> some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                headerSection(child: child)
                bankCardSection(child: child)
                activePiggyBanksSection(child: child)
            }
            .padding(.bottom, 80)
        }
        .background(Color.white)
        .navigationTitle(child.name)
    }

    private func headerSection(child: Children) -> some View {
        HStack(alignment: .center, spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color("primaryBlue"))
                    .frame(width: 56, height: 56)
                Text(child.avatarEmoji)
                    .font(FontType.regular.fontType(size: 28))
            }

            VStack(alignment: .leading, spacing: 2) {
                Text(child.name)
                    .font(FontType.bold.fontType(size: 22))
                    .foregroundStyle(.primary)
            }
            Spacer()
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 20)
        .background(Color(.systemBackground))
    }

    private func bankCardSection(child: Children) -> some View {
        BankCardView(
            cardTitle: "TBC Card",
            balance: child.balance,
            cardLastFour: String(child.iban.suffix(4))
        )
        .padding(.horizontal, 20)
        .padding(.top, 20)
    }

    private func activePiggyBanksSection(child: Children) -> some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                Text("Active Piggy Banks")
                    .font(FontType.bold.fontType(size: 18))
                    .foregroundStyle(.primary)
                Spacer()
                Button {
                    viewModel.showCreateGoalSheet = true
                } label: {
                    Image(systemName: "plus")
                        .font(FontType.medium.fontType(size: 16))
                        .foregroundStyle(.white)
                        .frame(width: 36, height: 36)
                        .background(Color("primaryBlue"))
                        .clipShape(Circle())
                }
            }

            let goals = viewModel.goals(for: child)
            if goals.isEmpty {
                Text("No piggy banks yet")
                    .font(FontType.regular.fontType(size: 16))
                    .foregroundStyle(.secondary)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 24)
            } else {
                VStack(spacing: 12) {
                    ForEach(goals) { goal in
                        GoalCard(
                            title: goal.title,
                            checkpointsCompleted: goal.checkpointsCompleted,
                            checkpointsTotal: goal.checkpointsTotal,
                            status: goal.status,
                            currentAmount: goal.currentAmount,
                            goalAmount: goal.goalAmount,
                            iconName: goal.iconName,
                            accentColor: Color("primaryBlue"),
                            checkpoints: goal.checkpoints
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }
}

#Preview {
    let vm = MyChildrenViewModel(children: [
        Children(name: "Sophie Anderson", role: .children, avatarEmoji: "👧", balance: 125.50, iban: "GE00XXXX4532")
    ])
    vm.selectChild(vm.children[0])
    return ChildInfoView(viewModel: vm)
}
