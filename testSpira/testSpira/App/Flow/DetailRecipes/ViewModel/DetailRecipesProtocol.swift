//
//  DetailRecipesProtocol.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
import UIKit
protocol DetailRecipesViewToViewModel {
    func succesGetDetailRecipe(detailRecipes: ProductOfList)
    func showError(error: String)
}

protocol DetailRecipesViewModelToView: AnyObject {
    func getDetailRecipes(controller:UIViewController, idProduct: Int)
}
