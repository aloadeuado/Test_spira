//
//  SearchWS.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation

class SearchWS {
    static func createTextSearch(text: String, email: String, complete: @escaping ((Bool, TextModel?, String) -> Void)) {
        let url = getBASE_UREL() + "/yape/api/addTextSearch"
        let dic = ["text": text, "email": email]
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .post, withData: dic, modelType: TextModel.self) { success, textModel, error in
            DispatchQueue.main.async {
                complete(success, textModel, error?.localizedDescription ?? "")
            }
        }
    }
    
    static func getTextSearch(email: String, complete: @escaping ((Bool, TextModel?, String) -> Void)) {
        let url = getBASE_UREL() + "/yape/api/getTextSearch"
        let dic = ["email": email]
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .post, withData: dic, modelType: TextModel.self) { success, textModel, error in
            DispatchQueue.main.async {
                complete(success, textModel, error?.localizedDescription ?? "")
            }
        }
    }
}
