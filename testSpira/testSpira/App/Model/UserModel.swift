//
//  UserModel.swift
//  test_yape_ios
//
//  Created by iMac on 23/02/23.
//

import Foundation
class UserData: Codable {
    let data: UserModel?
    let message, error: String?
}
class UserModel: Codable {
    let email, token, password: String?
    init(email: String?, token: String?, password: String?) {
        self.email = email
        self.token = token
        self.password = password
    }
}
