//
//  ChildDTO.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

struct PiggyBankDTO: Codable {
    let piggyBankId: Int
    let title: String
    let targetAmount: Int
    let currentAmount: Int
    let bonusOnReach: Int?
    let iconUrl: String?
    let childId: Int
    let parentId: Int
    let isApproved: Bool
    let isCompleted: Bool
    let checkpoints: [CheckpointDTO]?

    enum CodingKeys: String, CodingKey {
        case piggyBankId, title, targetAmount, currentAmount, bonusOnReach
        case iconUrl, childId, parentId, isApproved, isCompleted, checkpoints
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        piggyBankId = try c.decode(Int.self, forKey: .piggyBankId)
        title = try c.decode(String.self, forKey: .title)
        targetAmount = try c.decode(Int.self, forKey: .targetAmount)
        currentAmount = try c.decode(Int.self, forKey: .currentAmount)
        bonusOnReach = try c.decodeIfPresent(Int.self, forKey: .bonusOnReach)
        iconUrl = try c.decodeIfPresent(String.self, forKey: .iconUrl)
        childId = try c.decode(Int.self, forKey: .childId)
        parentId = try c.decode(Int.self, forKey: .parentId)
        isApproved = try c.decode(Bool.self, forKey: .isApproved)
        isCompleted = try c.decode(Bool.self, forKey: .isCompleted)
        checkpoints = try c.decodeIfPresent([CheckpointDTO].self, forKey: .checkpoints)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(piggyBankId, forKey: .piggyBankId)
        try c.encode(title, forKey: .title)
        try c.encode(targetAmount, forKey: .targetAmount)
        try c.encode(currentAmount, forKey: .currentAmount)
        try c.encodeIfPresent(bonusOnReach, forKey: .bonusOnReach)
        try c.encodeIfPresent(iconUrl, forKey: .iconUrl)
        try c.encode(childId, forKey: .childId)
        try c.encode(parentId, forKey: .parentId)
        try c.encode(isApproved, forKey: .isApproved)
        try c.encode(isCompleted, forKey: .isCompleted)
        try c.encodeIfPresent(checkpoints, forKey: .checkpoints)
    }
}

struct CheckpointDTO: Codable {
    let checkpointId: Int
    let piggyBankId: Int
    let level: Int
    let targetAmount: Int
    let prizeAmount: Int
    let rewardPoints: Int
    let isApprovedByParent: Bool
    let rewardGiven: Bool
    let reachedAt: String?

    enum CodingKeys: String, CodingKey {
        case checkpointId, piggyBankId, level, targetAmount, prizeAmount
        case rewardPoints, isApprovedByParent, rewardGiven, reachedAt
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        checkpointId = try c.decode(Int.self, forKey: .checkpointId)
        piggyBankId = try c.decode(Int.self, forKey: .piggyBankId)
        level = try c.decode(Int.self, forKey: .level)
        targetAmount = try c.decode(Int.self, forKey: .targetAmount)
        prizeAmount = try c.decodeIfPresent(Int.self, forKey: .prizeAmount) ?? 0
        rewardPoints = try c.decode(Int.self, forKey: .rewardPoints)
        isApprovedByParent = try c.decode(Bool.self, forKey: .isApprovedByParent)
        rewardGiven = try c.decode(Bool.self, forKey: .rewardGiven)
        reachedAt = try c.decodeIfPresent(String.self, forKey: .reachedAt)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(checkpointId, forKey: .checkpointId)
        try c.encode(piggyBankId, forKey: .piggyBankId)
        try c.encode(level, forKey: .level)
        try c.encode(targetAmount, forKey: .targetAmount)
        try c.encode(prizeAmount, forKey: .prizeAmount)
        try c.encode(rewardPoints, forKey: .rewardPoints)
        try c.encode(isApprovedByParent, forKey: .isApprovedByParent)
        try c.encode(rewardGiven, forKey: .rewardGiven)
        try c.encodeIfPresent(reachedAt, forKey: .reachedAt)
    }
}

struct ChildDTO: Codable {
    let id: Int
    let name: String
    let surname: String
    let balance: Int
    let role: Int
    let iban: String
    let piggyBanks: [PiggyBankDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, surname, balance, role, iban, piggyBanks
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        surname = try c.decodeIfPresent(String.self, forKey: .surname) ?? ""
        balance = try c.decode(Int.self, forKey: .balance)
        role = try c.decode(Int.self, forKey: .role)
        iban = try c.decodeIfPresent(String.self, forKey: .iban) ?? ""
        piggyBanks = try c.decodeIfPresent([PiggyBankDTO].self, forKey: .piggyBanks)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(surname, forKey: .surname)
        try c.encode(balance, forKey: .balance)
        try c.encode(role, forKey: .role)
        try c.encode(iban, forKey: .iban)
        try c.encodeIfPresent(piggyBanks, forKey: .piggyBanks)
    }
}
