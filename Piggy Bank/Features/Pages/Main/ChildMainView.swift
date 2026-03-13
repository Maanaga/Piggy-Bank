//
//  ChildMainView.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import SwiftUI

private struct AddMoneySheetContext: Identifiable {
    let id = UUID()
    let goals: [PiggyBankGoal]
    let sources: [PaymentSource]
    let childId: Int?
    let iban: String?
}

struct ChildMainView: View {
    let childId: Int?
    @State private var goals: [PiggyBankGoal]
    @State private var addMoneyContext: AddMoneySheetContext?
    @State private var isRefreshing = false
    private let childInfoService = ChildInfoNetworkService()

    init(goals initialGoals: [PiggyBankGoal] = [], childId: Int? = nil) {
        self.childId = childId
        _goals = State(initialValue: initialGoals)
    }

    private var addMoneyGoals: [PiggyBankGoal] {
        goals.isEmpty ? [Self.placeholderGoal] : goals
    }

    private func refreshGoals() async {
        guard let cid = childId else { return }
        await MainActor.run { isRefreshing = true }
        do {
            let info = try await childInfoService.getChildInfo(childId: cid)
            let updated = (info.piggyBanks ?? []).map { PiggyBankGoal.from(dto: $0) }
            await MainActor.run {
                goals = updated
                isRefreshing = false
            }
        } catch {
            await MainActor.run { isRefreshing = false }
        }
    }

    private static var placeholderGoal: PiggyBankGoal {
        PiggyBankGoal(
            id: UUID(),
            piggyBankId: 0,
            title: "Goal",
            iconName: "gift.fill",
            goalAmount: 0,
            checkpointsTotal: 1,
            currentAmount: 0,
            checkpointsCompleted: 0,
            status: .pending
        )
    }

    private static func sources(from childInfo: ChildInfoResponse?) -> [PaymentSource] {
        guard let info = childInfo else {
            return [PaymentSource(title: "My TBC Card", lastFour: "****", balance: 0)]
        }
        let ibanDigits = info.iban.replacingOccurrences(of: " ", with: "").trimmingCharacters(in: .whitespacesAndNewlines)
        let lastFour = ibanDigits.count >= 4 ? String(ibanDigits.suffix(4)) : ibanDigits
        return [PaymentSource(title: "My TBC Card", lastFour: lastFour, balance: Decimal(info.balance))]
    }

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    if isRefreshing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                    }
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
            .refreshable { await refreshGoals() }
            .background(Color(.systemBackground))
            .ignoresSafeArea(edges: .top)
            .navigationBarHidden(true)

            Button {
                if let cid = childId {
                    Task {
                        do {
                            let info = try await childInfoService.getChildInfo(childId: cid)
                            await MainActor.run {
                                addMoneyContext = AddMoneySheetContext(goals: addMoneyGoals, sources: Self.sources(from: info), childId: cid, iban: info.iban)
                            }
                        } catch {
                            await MainActor.run {
                                addMoneyContext = AddMoneySheetContext(goals: addMoneyGoals, sources: Self.sources(from: nil), childId: cid, iban: nil)
                            }
                        }
                    }
                } else {
                    addMoneyContext = AddMoneySheetContext(goals: addMoneyGoals, sources: Self.sources(from: nil), childId: nil, iban: nil)
                }
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
        .sheet(item: $addMoneyContext) { context in
            NavigationStack {
                AddMoneyView(
                    goals: context.goals,
                    sources: context.sources,
                    childId: context.childId,
                    iban: context.iban,
                    onBack: { addMoneyContext = nil },
                    onContinue: { _ in
                        Task {
                            await refreshGoals()
                        }
                        addMoneyContext = nil
                    }
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
                piggyBankId: 1,
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
