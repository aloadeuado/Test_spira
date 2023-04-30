//
//  ListRecipesProtocols.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit

protocol ListProductsViewToViewModel {
    func succesGetListProducts(listProducts: [ProductOfList])
    func successGetListText(textModel: TextModel)
    func successGetListText(locationModel: LocationModel)
    func showError(error: String)
}

protocol ListProductsViewModelToView: AnyObject {
    func getListProducts(controller: UIViewController, numberPerPage: Int)
    func addTextFastSearch(text: String)
    func getLocationData()
}
