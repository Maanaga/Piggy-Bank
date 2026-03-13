//
//  MyChildrenViewModel.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation
import Combine

struct PendingCheckpointApproval: Identifiable, Equatable {
    let piggyBankId: Int
    let checkpointId: Int
    let level: Int
    let goalTitle: String
    let amountSaved: Int
    let rewardPoints: Int
    let iconName: String

    var id: String { "\(piggyBankId)-\(checkpointId)" }
}

final class MyChildrenViewModel: ObservableObject {
    @Published var children: [Children]
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
    @Published private(set) var pendingCheckpointApprovals: [PendingCheckpointApproval] = []
    @Published var checkpointApprovalError: String?
    @Published var isApprovingCheckpoint: Bool = false

    var onBack: (() -> Void)?

    private let piggyBanksService: PiggyBanksNetworkService
    private let childInfoService: ChildInfoNetworkService

    static let goalIconSfSymbols: [String] = [
        "target", "bicycle", "gamecontroller.fill", "airplane", "iphone",
        "graduationcap.fill", "gift.fill", "heart.fill", "star.fill", "trophy.fill",
        "rocket.fill", "music.note", "camera.fill", "square", "paintpalette.fill",
        "tshirt.fill", "fork.knife", "birthday.cake.fill", "bag.fill", "house.fill"
    ]

    init(
        children: [Children],
        parentId: Int? = nil,
        initialGoalsByChildName: [String: [PiggyBankGoal]] = [:],
        piggyBanksService: PiggyBanksNetworkService = PiggyBanksNetworkService(),
        childInfoService: ChildInfoNetworkService = ChildInfoNetworkService()
    ) {
        self.children = children
        self.parentId = parentId
        self.piggyBanksService = piggyBanksService
        self.childInfoService = childInfoService
        self.checkpoints = [CheckpointRow(amount: "", parentContribution: "")]
        self.goalsByChildName = initialGoalsByChildName
    }

    func refreshChildrenBalances() async {
        guard !children.isEmpty else { return }
        var updated: [Children] = []
        for child in children {
            if let id = child.id {
                do {
                    let info = try await childInfoService.getChildInfo(childId: id)
                    let refreshed = Children(
                        id: child.id,
                        name: child.name,
                        role: child.role,
                        avatarEmoji: child.avatarEmoji,
                        balance: Decimal(info.balance),
                        iban: info.iban
                    )
                    updated.append(refreshed)
                } catch {
                    updated.append(child)
                }
            } else {
                updated.append(child)
            }
        }
        await MainActor.run {
            self.children = updated
        }
    }

    func selectChild(_ child: Children) {
        selectedChild = child
    }

    func clearSelectedChild() {
        selectedChild = nil
        pendingCheckpointApprovals = []
        checkpointApprovalError = nil
    }

    func refreshSelectedChildGoalsAndPendingApprovals() async {
        guard let child = selectedChild, let childId = child.id else { return }
        do {
            let info = try await childInfoService.getChildInfo(childId: childId)
            let piggyBanks = info.piggyBanks ?? []
            let mappedGoals = piggyBanks.map { PiggyBankGoal.from(dto: $0) }
            let approvals = pendingApprovals(from: piggyBanks)

            await MainActor.run {
                goalsByChildName[child.name] = mappedGoals
                pendingCheckpointApprovals = approvals
            }
        } catch {
            await MainActor.run {
                checkpointApprovalError = error.localizedDescription
            }
        }
    }

    func approvePendingCheckpoint(_ approval: PendingCheckpointApproval) async {
        await MainActor.run { isApprovingCheckpoint = true }
        do {
            try await piggyBanksService.redeemCheckpoint(
                piggyBankId: approval.piggyBankId,
                checkpointId: approval.checkpointId
            )
            await refreshSelectedChildGoalsAndPendingApprovals()
            await MainActor.run { isApprovingCheckpoint = false }
        } catch {
            await MainActor.run {
                isApprovingCheckpoint = false
                checkpointApprovalError = error.localizedDescription
            }
        }
    }

    func dismissPendingCheckpoint(_ approval: PendingCheckpointApproval) {
        pendingCheckpointApprovals.removeAll { $0.id == approval.id }
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
        checkpoints.append(CheckpointRow(amount: "", parentContribution: ""))
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
        checkpoints = [CheckpointRow(amount: "", parentContribution: "")]
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

    private func pendingApprovals(from piggyBanks: [PiggyBankDTO]) -> [PendingCheckpointApproval] {
        piggyBanks
            .flatMap { piggyBank in
                let iconName = (piggyBank.iconUrl?.trimmingCharacters(in: .whitespacesAndNewlines))
                    .flatMap { $0.isEmpty ? nil : $0 } ?? "gift.fill"
                return (piggyBank.checkpoints ?? [])
                    .filter { ($0.reachedAt != nil || piggyBank.currentAmount >= $0.targetAmount) && !$0.isApprovedByParent }
                    .map {
                        PendingCheckpointApproval(
                            piggyBankId: piggyBank.piggyBankId,
                            checkpointId: $0.checkpointId,
                            level: $0.level,
                            goalTitle: piggyBank.title,
                            amountSaved: $0.targetAmount,
                            rewardPoints: $0.rewardPoints,
                            iconName: iconName
                        )
                    }
            }
            .sorted { lhs, rhs in
                if lhs.level == rhs.level {
                    return lhs.piggyBankId < rhs.piggyBankId
                }
                return lhs.level < rhs.level
            }
    }
}
