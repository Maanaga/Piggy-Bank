//
//  UserSessionStorage.swift
//  Piggy Bank
//
//  Created by Luka Managadze on 13.03.26.
//

import Foundation

enum UserSessionStorage {
    private static let key = "savedSignInResponse"

    static func save(_ response: SignInResponse) {
        guard let data = try? JSONEncoder().encode(response) else { return }
        UserDefaults.standard.set(data, forKey: key)
    }

    static func load() -> SignInResponse? {
        guard let data = UserDefaults.standard.data(forKey: key),
              let response = try? JSONDecoder().decode(SignInResponse.self, from: data) else {
            return nil
        }
        return response
    }

    static func clear() {
        UserDefaults.standard.removeObject(forKey: key)
    }
}
