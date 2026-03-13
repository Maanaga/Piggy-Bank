//
//  ChildMainView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildMainView: View {
    let goals: [PiggyBankGoal]
    @State private var showAddMoney = false

    init(goals: [PiggyBankGoal] = []) {
        self.goals = goals
    }

    private var addMoneyGoal: PiggyBankGoal? {
        goals.first ?? Self.placeholderGoal
    }

    private static var placeholderGoal: PiggyBankGoal {
        PiggyBankGoal(
            id: UUID(),
            title: "Goal",
            iconName: "gift.fill",
            goalAmount: 0,
            checkpointsTotal: 1,
            currentAmount: 0,
            checkpointsCompleted: 0,
            status: .pending
        )
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        headerSection
                        totalProgressSection
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 48)
                    .background(
                        Color("primaryBlue")
                            .ignoresSafeArea(edges: .top)
                    )

                    yourGoalsSection
                }
                .padding(.bottom, 80)
            }
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)

            Button {
                showAddMoney = true
            } label: {
                Image(systemName: "plus")
                    .font(FontType.medium.fontType(size: 24))
                    .foregroundStyle(.white)
                    .frame(width: 56, height: 56)
                    .background(Color("primaryBlue"))
                    .clipShape(Circle())
            }
            .padding(.trailing, 20)
            .padding(.bottom, 40)
        }
        .sheet(isPresented: $showAddMoney) {
            if let goal = addMoneyGoal {
                NavigationStack {
                    AddMoneyView(
                        goal: goal,
                        onBack: { showAddMoney = false },
                        onContinue: { _ in showAddMoney = false }
                    )
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("My Piggy Banks 🐷")
                    .font(FontType.bold.fontType(size: 28))
                    .foregroundStyle(.white)
            }
            Text("Keep saving to reach your goals!")
                .font(FontType.regular.fontType(size: 14))
                .foregroundStyle(.white.opacity(0.95))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 20)
        .padding(.top, 80)
        .padding(.bottom, 20)
    }

    private var totalProgressSection: some View {
        let totalCurrent = goals.reduce(0) { $0 + $1.currentAmount }
        let totalTarget = goals.reduce(0) { $0 + $1.goalAmount }
        return TotalProgressCard(currentAmount: totalCurrent, targetAmount: max(totalTarget, 1))
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }

    private var yourGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Goals")
                .font(FontType.bold.fontType(size: 18))
                .foregroundStyle(.primary)

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
                            accentColor: Color("primaryBlue")
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
    NavigationStack {
        ChildMainView(goals: [
            PiggyBankGoal(
                id: UUID(),
                title: "Bass Guitar",
                iconName: "gift.fill",
                goalAmount: 1000,
                checkpointsTotal: 2,
                currentAmount: 450,
                checkpointsCompleted: 1,
                status: .pending
            )
        ])
    }
}
