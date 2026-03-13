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
    let goal: PiggyBankGoal
    let sources: [PaymentSource]

    @Published var selectedAmount: Int = 0
    @Published var isCustomMode: Bool = false
    @Published var customAmountText: String = "0"

    var displayAmount: Int {
        if isCustomMode {
            return Int(customAmountText.filter { $0.isNumber }) ?? 0
        }
        return selectedAmount
    }

    var canContinue: Bool {
        displayAmount > 0
    }

    init(goal: PiggyBankGoal, sources: [PaymentSource] = []) {
        self.goal = goal
        self.sources = sources.isEmpty ? [PaymentSource(title: "My TBC Card", lastFour: "4532", balance: 125.50)] : sources
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
