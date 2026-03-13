//
//  ChildDTO.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//


struct ChildDTO: Decodable {
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
}