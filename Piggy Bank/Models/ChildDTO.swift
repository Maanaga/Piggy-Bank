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
    let bonusOnReach: Int
    let childId: Int
    let parentId: Int
    let isApproved: Bool
    let isCompleted: Bool
    let checkpoints: [CheckpointDTO]?

    enum CodingKeys: String, CodingKey {
        case piggyBankId, title, targetAmount, currentAmount, bonusOnReach
        case childId, parentId, isApproved, isCompleted, checkpoints
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        piggyBankId = try c.decode(Int.self, forKey: .piggyBankId)
        title = try c.decode(String.self, forKey: .title)
        targetAmount = try c.decode(Int.self, forKey: .targetAmount)
        currentAmount = try c.decode(Int.self, forKey: .currentAmount)
        bonusOnReach = try c.decode(Int.self, forKey: .bonusOnReach)
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
        try c.encode(bonusOnReach, forKey: .bonusOnReach)
        try c.encode(childId, forKey: .childId)
        try c.encode(parentId, forKey: .parentId)
        try c.encode(isApproved, forKey: .isApproved)
        try c.encode(isCompleted, forKey: .isCompleted)
        try c.encodeIfPresent(checkpoints, forKey: .checkpoints)
    }
}

struct CheckpointDTO: Codable {}

struct ChildDTO: Codable {
    let id: Int
    let name: String
    let surname: String
    let balance: Int
    let role: Int
    let piggyBanks: [PiggyBankDTO]?

    enum CodingKeys: String, CodingKey {
        case id, name, surname, balance, role, piggyBanks
    }

    init(from decoder: Decoder) throws {
        let c = try decoder.container(keyedBy: CodingKeys.self)
        id = try c.decode(Int.self, forKey: .id)
        name = try c.decode(String.self, forKey: .name)
        surname = try c.decodeIfPresent(String.self, forKey: .surname) ?? ""
        balance = try c.decode(Int.self, forKey: .balance)
        role = try c.decode(Int.self, forKey: .role)
        piggyBanks = try c.decodeIfPresent([PiggyBankDTO].self, forKey: .piggyBanks)
    }

    func encode(to encoder: Encoder) throws {
        var c = encoder.container(keyedBy: CodingKeys.self)
        try c.encode(id, forKey: .id)
        try c.encode(name, forKey: .name)
        try c.encode(surname, forKey: .surname)
        try c.encode(balance, forKey: .balance)
        try c.encode(role, forKey: .role)
        try c.encodeIfPresent(piggyBanks, forKey: .piggyBanks)
    }
}
