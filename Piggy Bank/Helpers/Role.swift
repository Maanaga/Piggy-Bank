//
//  Role.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 12.03.26.
//


enum Role {
    case children
    case parent

    static func from(apiValue: Int) -> Role {
        apiValue == 0 ? .parent : .children
    }
}
