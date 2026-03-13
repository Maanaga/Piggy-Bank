//
//  MyChildrenViewModel.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation
import Combine

final class MyChildrenViewModel: ObservableObject {
    let children: [Children]
    let parentId: Int?
    var onChildSelected: ((Children) -> Void)?

    @Published private(set) var selectedChild: Children?

    @Published var goalsByChildName: [String: [PiggyBankGoal]] = [:]

    @Published var showCreateGoalSheet: Bool = false
    @Published var step: Int = 1
    @Published var goalName: String = ""
    @Published var selectedIconIndex: Int? = nil
    @Published var goalAmount: String = ""
    @Published var checkpoints: [CheckpointRow]
    @Published var step1Errors: Step1ValidationErrors = Step1ValidationErrors()
    @Published var step2Errors: Step2ValidationErrors = Step2ValidationErrors()
    @Published var isCreatingGoal: Bool = false
    @Published var createGoalError: String?

    var onBack: (() -> Void)?

    private let piggyBanksService: PiggyBanksNetworkService

    static let goalIconSfSymbols: [String] = [
        "target", "bicycle", "gamecontroller.fill", "airplane", "iphone",
        "graduationcap.fill", "gift.fill", "heart.fill", "star.fill", "trophy.fill",
        "rocket.fill", "music.note", "camera.fill", "square", "paintpalette.fill",
        "tshirt.fill", "fork.knife", "birthday.cake.fill", "bag.fill", "house.fill"
    ]

    init(children: [Children], parentId: Int? = nil, initialGoalsByChildName: [String: [PiggyBankGoal]] = [:], piggyBanksService: PiggyBanksNetworkService = PiggyBanksNetworkService()) {
        self.children = children
        self.parentId = parentId
        self.piggyBanksService = piggyBanksService
        self.checkpoints = [CheckpointRow(amount: "0", parentContribution: "0")]
        self.goalsByChildName = initialGoalsByChildName
    }

    func selectChild(_ child: Children) {
        selectedChild = child
    }

    func clearSelectedChild() {
        selectedChild = nil
    }

    func dismissCreateGoalSheet() {
        showCreateGoalSheet = false
    }

    func validateAndGoToStep2() {
        let nameTrimmed = goalName.trimmingCharacters(in: .whitespacesAndNewlines)
        var errors = Step1ValidationErrors()
        if nameTrimmed.isEmpty {
            errors.goalName = "Goal name is required"
        }
        let amountTrimmed = goalAmount.trimmingCharacters(in: .whitespacesAndNewlines)
        if amountTrimmed.isEmpty {
            errors.goalAmount = "Goal amount is required"
        } else if let value = parseDecimal(amountTrimmed), value <= 0 {
            errors.goalAmount = "Enter a valid amount greater than 0"
        } else if parseDecimal(amountTrimmed) == nil {
            errors.goalAmount = "Enter a valid amount"
        }
        if selectedIconIndex == nil {
            errors.icon = "Please choose an icon"
        }
        step1Errors = errors
        if errors.isEmpty {
            step = 2
        }
    }

    func goBackToStep1() {
        step = 1
        step1Errors = Step1ValidationErrors()
        step2Errors = Step2ValidationErrors()
    }

    func addCheckpoint() {
        checkpoints.append(CheckpointRow(amount: "0", parentContribution: "0"))
        step2Errors = Step2ValidationErrors(
            checkpointErrors: step2Errors.checkpointErrors + [(nil, nil)]
        )
    }

    func validateAndCreateGoal() {
        var errors: [(amount: String?, parentContribution: String?)] = []
        for checkpoint in checkpoints {
            var amountError: String?
            var contributionError: String?
            let amountTrimmed = checkpoint.amount.trimmingCharacters(in: .whitespacesAndNewlines)
            if amountTrimmed.isEmpty {
                amountError = "Amount is required"
            } else if let value = parseDecimal(checkpoint.amount), value < 0 {
                amountError = "Enter a valid amount"
            } else if parseDecimal(checkpoint.amount) == nil {
                amountError = "Enter a valid amount"
            }
            let contributionTrimmed = checkpoint.parentContribution.trimmingCharacters(in: .whitespacesAndNewlines)
            if contributionTrimmed.isEmpty {
                contributionError = "Parent contribution is required"
            } else if let value = parseDecimal(checkpoint.parentContribution), value < 0 {
                contributionError = "Enter a valid amount"
            } else if parseDecimal(checkpoint.parentContribution) == nil {
                contributionError = "Enter a valid amount"
            }
            errors.append((amountError, contributionError))
        }
        step2Errors = Step2ValidationErrors(checkpointErrors: errors)
        guard step2Errors.isEmpty, let child = selectedChild, let pid = parentId, let childId = child.id else {
            if parentId == nil {
                createGoalError = "Unable to create goal. Please sign in again."
            } else if selectedChild?.id == nil {
                createGoalError = "Child information is missing."
            }
            return
        }
        createGoalError = nil
        Task { @MainActor in
            await performCreateGoal(parentId: pid, childId: childId, child: child)
        }
    }

    private func performCreateGoal(parentId: Int, childId: Int, child: Children) async {
        isCreatingGoal = true
        defer { isCreatingGoal = false }

        let title = goalName.trimmingCharacters(in: .whitespacesAndNewlines)
        let targetAmount = (parseDecimal(goalAmount.trimmingCharacters(in: .whitespacesAndNewlines)) as NSDecimalNumber?)?.intValue ?? 0
        let endDate = Calendar.current.date(byAdding: .year, value: 1, to: Date()) ?? Date()

        var checkpointPayloads: [(targetAmount: Int, amountPrize: Int)] = []
        for cp in checkpoints {
            let amount = (parseDecimal(cp.amount.trimmingCharacters(in: .whitespacesAndNewlines)) as NSDecimalNumber?)?.intValue ?? 0
            let prize = (parseDecimal(cp.parentContribution.trimmingCharacters(in: .whitespacesAndNewlines)) as NSDecimalNumber?)?.intValue ?? 0
            checkpointPayloads.append((targetAmount: amount, amountPrize: prize))
        }

        let iconName: String
        if let idx = selectedIconIndex, idx >= 0, idx < Self.goalIconSfSymbols.count {
            iconName = Self.goalIconSfSymbols[idx]
        } else {
            iconName = "gift.fill"
        }

        do {
            _ = try await piggyBanksService.createPiggyBank(
                parentId: parentId,
                childId: childId,
                title: title,
                targetAmount: max(0, targetAmount),
                bonusOnReach: nil,
                iconUrl: iconName,
                endDate: endDate,
                checkpoints: checkpointPayloads
            )
            let newGoal = PiggyBankGoal.new(
                title: title,
                iconName: iconName,
                goalAmount: max(0, targetAmount),
                checkpointsTotal: checkpoints.count
            )
            goalsByChildName[child.name, default: []].append(newGoal)
            resetCreateGoalForm()
            dismissCreateGoalSheet()
        } catch {
            createGoalError = error.localizedDescription
        }
    }

    func resetCreateGoalForm() {
        step = 1
        goalName = ""
        selectedIconIndex = nil
        goalAmount = ""
        checkpoints = [CheckpointRow(amount: "0", parentContribution: "0")]
        step1Errors = Step1ValidationErrors()
        step2Errors = Step2ValidationErrors()
    }

    func goals(for child: Children) -> [PiggyBankGoal] {
        goalsByChildName[child.name] ?? []
    }

    func parseDecimal(_ string: String) -> Decimal? {
        let normalized = string.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".")
        return Decimal(string: normalized)
    }
}
