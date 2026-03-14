//
//  Children.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//

import Foundation

struct Children {
    let id: Int?
    let name: String
    let role: Role
    let avatarEmoji: String
    let balance: Decimal
    let iban: String

    init(id: Int? = nil, name: String, role: Role, avatarEmoji: String, balance: Decimal, iban: String) {
        self.id = id
        self.name = name
        self.role = role
        self.avatarEmoji = avatarEmoji
        self.balance = balance
        self.iban = iban
    }

    static func from(dto: ChildDTO) -> Children {
        let displayName = dto.surname.isEmpty ? dto.name : "\(dto.name) \(dto.surname)"
        return Children(
            id: dto.id,
            name: displayName,
            role: Role.from(apiValue: dto.role),
            avatarEmoji: dto.role == 0 ? "👤" : "👧",
            balance: Decimal(dto.balance),
            iban: dto.iban
        )
    }
}
