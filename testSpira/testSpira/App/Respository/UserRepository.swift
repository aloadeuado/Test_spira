//
//  UserRepository.swift
//  test_yape_ios
//
//  Created by iMac on 23/02/23.
//

import Foundation

struct UserRespository {
    static func signInUser(userModel: UserModel, complete: @escaping ((Bool, UserData?, String) -> Void)) {
        let url = getBASE_UREL() + "/spira/api/registerOrAuth"
        let dic = ["email": userModel.email, "password": userModel.password, "token": userModel.token]
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .post, withData: dic, modelType: UserData.self) { success, userData, error in
            DispatchQueue.main.async {
                complete(success, userData, error?.localizedDescription ?? "")
            }
        }
    }
}
