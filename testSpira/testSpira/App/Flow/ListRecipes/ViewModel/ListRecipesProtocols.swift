//
//  ListRecipesProtocols.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit

protocol ListRecipesViewToViewModel {
    func succesGetListRecipes(listRecipes: ListRecipes, text: String)
    func successGetListText(textModel: TextModel)
    func successGetListText(locationModel: LocationModel)
    func showError(error: String)
}

protocol ListRecipesViewModelToView: AnyObject {
    func getListRecipes(controller:UIViewController, text: String, offsetPage: Int, numberPerPage: Int)
    func addTextFastSearch(text: String)
    func getLocationData()
}
