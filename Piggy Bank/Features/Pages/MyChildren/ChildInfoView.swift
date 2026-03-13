//
//  ChildInfoView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildInfoView: View {
    @ObservedObject var viewModel: MyChildrenViewModel

    var body: some View {
        Group {
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
                    ForEach(Array(goals.enumerated()), id: \.element.id) { index, goal in
                        GoalCard(
                            title: goal.title,
                            checkpointsCompleted: goal.checkpointsCompleted,
                            checkpointsTotal: goal.checkpointsTotal,
                            status: goal.status,
                            currentAmount: goal.currentAmount,
                            goalAmount: goal.goalAmount,
                            iconName: goal.iconName,
                            accentColor: Self.goalAccentColor(for: index)
                        )
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    private static let goalAccentColors: [Color] = [
        Color("primaryBlue"),
        Color("primaryGreen"),
        Color("primaryOrange")
    ]

    private static func goalAccentColor(for index: Int) -> Color {
        goalAccentColors[index % goalAccentColors.count]
    }
}

#Preview {
    let vm = MyChildrenViewModel(children: [
        Children(name: "Sophie Anderson", role: .children, avatarEmoji: "👧", balance: 125.50, iban: "GE00XXXX4532")
    ])
    vm.selectChild(vm.children[0])
    return ChildInfoView(viewModel: vm)
}
