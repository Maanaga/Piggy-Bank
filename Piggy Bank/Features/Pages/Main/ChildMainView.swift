//
//  ChildMainView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

struct ChildMainView: View {
    @State private var showAddMoney = false

    private static var defaultAddMoneyGoal: PiggyBankGoal {
        PiggyBankGoal(
            id: UUID(),
            title: "New Bicycle",
            iconName: "bicycle",
            goalAmount: 250,
            checkpointsTotal: 6,
            currentAmount: 175,
            checkpointsCompleted: 4,
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

            addMoneyFAB
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showAddMoney) {
            NavigationStack {
                AddMoneyView(
                    goal: Self.defaultAddMoneyGoal,
                    onBack: { showAddMoney = false },
                    onContinue: { _ in showAddMoney = false }
                )
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
        TotalProgressCard(currentAmount: 220, targetAmount: 330)
            .padding(.horizontal, 20)
            .padding(.top, 20)
    }

    private var yourGoalsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Goals")
                .font(FontType.bold.fontType(size: 18))
                .foregroundStyle(.primary)

            VStack(spacing: 12) {
                GoalCard(
                    title: "New Bicycle",
                    checkpointsCompleted: 4,
                    checkpointsTotal: 6,
                    status: .pending,
                    currentAmount: 175,
                    goalAmount: 250,
                    iconName: "bicycle",
                    accentColor: Color("primaryBlue")
                )
                GoalCard(
                    title: "Art Supplies",
                    checkpointsCompleted: 2,
                    checkpointsTotal: 4,
                    status: .completed,
                    currentAmount: 45,
                    goalAmount: 80,
                    iconName: "paintpalette.fill",
                    accentColor: Color("primaryGreen")
                )
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 24)
    }

    private var addMoneyFAB: some View {
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
}

#Preview {
    NavigationStack {
        ChildMainView()
    }
}
