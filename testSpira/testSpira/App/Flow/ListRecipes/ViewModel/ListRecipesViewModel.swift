//
//  ListRecipesViewModel.swift
//  test_empowermentlabs
//
//  Created by iMac on 9/02/23.
//

import Foundation
import UIKit
class ListRecipesViewModel {
    var listRecipesViewToViewModel: ListRecipesViewToViewModel?
    init(listRecipesViewToViewModel: ListRecipesViewToViewModel) {
        self.listRecipesViewToViewModel = listRecipesViewToViewModel
    }
}
//MARK: -ListRecipesViewModelToView
extension ListRecipesViewModel: ListRecipesViewModelToView {
    func getListRecipes(controller: UIViewController, text: String, offsetPage: Int, numberPerPage: Int) {
        Recipes.getListRecipes(text: text, offsetOnPage: offsetPage, numberOfItems: numberPerPage) {[weak self] success, listRecipes, error in
            if success {
                guard let self = self, let listRecipes = listRecipes else {return}
                self.listRecipesViewToViewModel?.succesGetListRecipes(listRecipes: listRecipes, text: text)
            } else {
                controller.view.makeToast(error)
            }
        }
    }
    
    func getLocationData() {
        
        LocationsWS.getLocationRecipe() {[weak self] successs, locationData, error in
            guard let self = self else {return}
            if let locationData = locationData {
                self.listRecipesViewToViewModel?.successGetListText(locationModel: locationData)
            }
        }

    }
    
    func addTextFastSearch(text: String) {
        SearchWS.createTextSearch(text: text, email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listRecipesViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listRecipesViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listRecipesViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getTextFastSearch(){
        SearchWS.getTextSearch(email: UserDefault.getDefaultUser()?.data?.email ?? "") { [weak self] success, textModel, error in
            guard let self = self else {return}
            if let textModel1 = textModel, let error = textModel1.error {
                self.listRecipesViewToViewModel?.showError(error: error)
            } else if let textModel1 = textModel {
                self.listRecipesViewToViewModel?.successGetListText(textModel: textModel1)
            } else {
                self.listRecipesViewToViewModel?.showError(error: "Ha ocurrido un error")
            }
        }
    }
    
    func getListFavoriteREcipesIds() -> [Result] {
        return FavoriteDefault.getFavoriteRecipe()
    }
    
    func addAndRemoveFavoriteId(result: Result) {
        FavoriteDefault.addFavoriteRecipe(result: result)
    }
    
    func getListPage(listRecipes: ListRecipes) -> [String] {
        var listText = [String]()
        let listData:Int = (listRecipes.totalResults ?? 0) / 10

        var index1 = 0
        for _ in 0...listData {
            
            index1 += 10
            listText.append("\(index1 - 9)...\(index1)")
        }
        if ((listRecipes.totalResults ?? 0) % 10) > 0 {
            listText.append("\(index1 - 9)...\((listRecipes.totalResults ?? 0))")
        }
        
        return listText
    }
}
