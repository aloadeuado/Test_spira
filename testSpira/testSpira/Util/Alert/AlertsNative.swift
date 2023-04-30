//
//  AlertsNative.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
import UIKit
class AlertsNative {
    static func showSimpleAlertNoAction(contorller: UIViewController, titleText: String, subTitleText: String, textButton: String = "Ok") {
        let alert = UIAlertController(title: titleText, message: subTitleText, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: textButton, style: .default, handler: { action in
            switch action.style {
                case .default:
                print("default")
                
                case .cancel:
                print("cancel")
                
                case .destructive:
                print("destructive")
                
            }
        }))
        contorller.present(alert, animated: true, completion: nil)
    }
}
