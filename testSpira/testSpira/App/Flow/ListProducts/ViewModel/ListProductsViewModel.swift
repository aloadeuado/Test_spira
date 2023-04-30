//
//  ListRecipesViewModel.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit
class ListProductsViewModel {
    var listProductsViewToViewModel: ListProductsViewToViewModel?
    init(listProductsViewToViewModel: ListProductsViewToViewModel) {
        self.listProductsViewToViewModel = listProductsViewToViewModel
    }
}
//MARK: -ListProductsViewModelToView
extension ListProductsViewModel: ListProductsViewModelToView {
    func getListProducts(controller: UIViewController, numberPerPage: Int) {
        
        Products.getListProducts(numberOfItems: numberPerPage) { [weak self] success, listProducts, error in
            if success {
                guard let self = self, let listRecipes = listProducts else {return}
                self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listRecipes)
            } else {
                controller.view.makeToast(error)
            }
        }
    }
    
    func getLocationData() {
        
        LocationsWS.getLocationRecipe() {[weak self] successs, locationData, error in
            guard let self = self else {return}
            if let locationData = locationData {
                self.listProductsViewToViewModel?.successGetListText(locationModel: locationData)
            }
        }

    }
    
    func addTextFastSearch(text: String) {
        SearchWS.createTextSearch(text: text, email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getTextFastSearch(){
        SearchWS.getTextSearch(email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listProductsViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listProductsViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listProductsViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getListFavoriteREcipesIds() -> [ProductOfList] {
        return FavoriteDefault.getFavoriteRecipe()
    }
    
    func addAndRemoveFavoriteId(result: ProductOfList) {
        FavoriteDefault.addFavoriteRecipe(result: result)
    }
    
    func getListPage(listProducts: [ProductOfList]) -> [String] {
        var listText = [String]()
        let listData:Int = (listProducts.count ?? 0) / 10

        var index1 = 0
        for _ in 0...listData {
            
            index1 += 10
            listText.append("\(index1 - 9)...\(index1)")
        }
        if ((listProducts.count ?? 0) % 10) > 0 {
            listText.append("\(index1 - 9)...\((listProducts.count ?? 0))")
        }
        
        return listText
    }
}
