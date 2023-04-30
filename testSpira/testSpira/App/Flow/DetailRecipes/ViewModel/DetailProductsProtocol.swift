//
//  DetailProductsProtocol.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
import UIKit
protocol DetailProductsViewToViewModel {
    func succesGetDetailProduct(detailProduct: ProductOfList)
    func showError(error: String)
}

protocol DetailProductsViewModelToView: AnyObject {
    func getDetailProducts(controller:UIViewController, idProduct: Int)
}
