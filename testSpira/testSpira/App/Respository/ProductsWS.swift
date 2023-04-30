//
//  ProductsWS.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation

struct Products {
    static func getListProducts(numberOfItems: Int, complete: @escaping ((Bool, [ProductOfList]?, String) -> Void)) {
        let url = getListProducstUrl().replacingOccurrences(of: "&{number}", with: "\(numberOfItems)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: [ProductOfList].self) { success, listProduct, error in
            DispatchQueue.main.async {
                complete(success, listProduct, error?.localizedDescription ?? "")
            }
        }
    }
    
    static func getDetailProduct(idProduct: Int, complete: @escaping ((Bool, ProductOfList?, String) -> Void) ) {
        let url = getDetailProductUrl().replacingOccurrences(of: "&{idProduct}", with: "\(idProduct)")
        
        ApiServices().requestHttpwithUrl(EpUrl: url, method: .get, withData: [:], modelType: ProductOfList.self) { success, detailProduct, error in
            DispatchQueue.main.async {
                complete(success, detailProduct, error?.localizedDescription ?? "")
            }
        }
    }
}
