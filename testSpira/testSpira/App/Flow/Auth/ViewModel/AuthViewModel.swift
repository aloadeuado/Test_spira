//
//  AuthViewModel.swift
//  test_yape_ios
//
//  Created by iMac on 23/02/23.
//

import Foundation
import GoogleSignIn

protocol AuthViewModelDelegate {
    func onCompleteGetUser(userData: UserData)
    func onShowError(error: String)
}
class AuthViewModel: AuthViewModelViewToViewModel {
    
    var authViewModelViewModelToView: AuthViewModelViewModelToView?
    init(authViewModelViewModelToView: AuthViewModelViewModelToView) {
        self.authViewModelViewModelToView = authViewModelViewModelToView
    }
    
    func signInGoogle(controller: UIViewController) {
        let signInConfig = GIDConfiguration.init(clientID: getGoogleKey())
        GIDSignIn.sharedInstance.signIn(with: signInConfig, presenting: controller) { [weak self] signInResult, error in

            guard let self = self else {return}
            if error != nil {
                self.authViewModelViewModelToView?.onShowError(error: error.debugDescription)
                return
            }
            let userModel = UserModel(email: signInResult?.profile?.email ?? "", token: signInResult?.userID ?? "", password: "")
            self.getUser(userModel: userModel)
            // If sign in succeeded, display the app's main content View.
          }
    }
    
    func validateUser() {
        if let userData = UserDefault.getDefaultUser() {
            authViewModelViewModelToView?.onCompleteGetUser(userData: userData)
        }
    }
    func signInEmail(userModel: UserModel) {
        getUser(userModel: userModel)
    }
    
    func getUser(userModel: UserModel) {
        UserRespository.signInUser(userModel: userModel) { [weak self] success, userData, error in
            guard let self = self else {return}

            if let userData1 = userData, let error = userData1.error {
                self.authViewModelViewModelToView?.onShowError(error: error)
            } else if let userData1 = userData {
                UserDefault.createDefaultUser(userData: userData1)
                self.authViewModelViewModelToView?.onCompleteGetUser(userData: userData1)
            } else {
                self.authViewModelViewModelToView?.onShowError(error: "Ha ocurrido un error")
            }
        }
    }
}
