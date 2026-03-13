//
//  ChildDTO.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//


struct ChildDTO: Codable {
    let id: Int
    let name: String
    let surname: String
    let balance: Int
    let role: Int
    let piggyBanks: [PiggyBankRefDTO]?

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
        piggyBanks = try c.decodeIfPresent([PiggyBankRefDTO].self, forKey: .piggyBanks)
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