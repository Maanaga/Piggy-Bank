//
//  AddMoneyViewModel.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation
import Combine

struct PaymentSource: Identifiable {
    let id = UUID()
    let title: String
    let lastFour: String
    let balance: Decimal
}

final class AddMoneyViewModel: ObservableObject {
    let goals: [PiggyBankGoal]
    let sources: [PaymentSource]
    let childId: Int?
    let iban: String?
    private let transferService: ChildTransferNetworkService

    @Published var selectedGoal: PiggyBankGoal
    @Published var selectedAmount: Int = 0
    @Published var isCustomMode: Bool = false
    @Published var customAmountText: String = "0"
    @Published var isTransferring = false
    @Published var transferError: String?

    var displayAmount: Int {
        if isCustomMode {
            return Int(customAmountText.filter { $0.isNumber }) ?? 0
        }
        return selectedAmount
    }

    var canContinue: Bool {
        displayAmount > 0
    }

    var canTransfer: Bool {
        guard let childId = childId, let iban = iban, !iban.isEmpty else { return false }
        return selectedGoal.piggyBankId > 0
    }

    init(goals: [PiggyBankGoal], sources: [PaymentSource] = [], childId: Int? = nil, iban: String? = nil, transferService: ChildTransferNetworkService = ChildTransferNetworkService()) {
        self.goals = goals.isEmpty ? [PiggyBankGoal(id: UUID(), piggyBankId: 0, title: "Goal", iconName: "gift.fill", goalAmount: 0, checkpointsTotal: 1, currentAmount: 0, checkpointsCompleted: 0, status: .pending)] : goals
        self.selectedGoal = self.goals[0]
        self.sources = sources.isEmpty ? [PaymentSource(title: "My TBC Card", lastFour: "4532", balance: 125.50)] : sources
        self.childId = childId
        self.iban = iban
        self.transferService = transferService
    }

    func selectGoal(_ goal: PiggyBankGoal) {
        selectedGoal = goal
    }

    func confirmTransfer() async {
        guard canTransfer else {
            transferError = "Missing account or goal information."
            return
        }
        guard let childId = childId, let iban = iban else { return }
        isTransferring = true
        transferError = nil
        do {
            try await transferService.transferToPiggyBank(
                childId: childId,
                depositAmount: Double(displayAmount),
                iban: iban,
                piggyBankId: selectedGoal.piggyBankId
            )
            await MainActor.run {
                isTransferring = false
            }
        } catch {
            await MainActor.run {
                transferError = error.localizedDescription
                isTransferring = false
            }
        }
    }

    func selectQuickAmount(_ amount: Int) {
        isCustomMode = false
        customAmountText = "0"
        selectedAmount = amount
    }

    func selectCustom() {
        isCustomMode = true
        selectedAmount = 0
    }

    func continueTapped() {
        // TODO: Submit add money flow
    }
}

