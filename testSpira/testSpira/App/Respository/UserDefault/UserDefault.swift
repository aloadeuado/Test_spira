//
//  UserDefault.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
class UserDefault {
    static func createDefaultUser(userData: UserData) {
        let defaults = UserDefaults.standard
        if let encoded = try? JSONEncoder().encode(userData) {
            defaults.set(encoded, forKey: "kUserData")
        }
    }
    
    static func getDefaultUser() -> UserData? {
        let defaults = UserDefaults.standard
        if let data = defaults.value(forKey: "kUserData") as? Data {
            if let userData = try? JSONDecoder().decode(UserData.self, from: data) {
                return userData
            }
        }
        return nil
    }
}
