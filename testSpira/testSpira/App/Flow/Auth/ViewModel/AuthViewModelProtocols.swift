//
//  AuthViewModelProtocols.swift
//  test_yape_ios
//
//  Created by iMac on 23/02/23.
//

import Foundation
import UIKit

protocol AuthViewModelViewToViewModel: AnyObject {
    func signInGoogle(controller: UIViewController)
    func signInEmail(userModel: UserModel)
    func validateUser()
}

protocol AuthViewModelViewModelToView: AnyObject {
    func onCompleteGetUser(userData: UserData)
    func onShowError(error: String)
}
