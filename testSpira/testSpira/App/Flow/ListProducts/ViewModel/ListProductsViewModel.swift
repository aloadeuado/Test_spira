//
//  ListProductsViewModel.swift
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
    func getListProducts(controller: UIViewController, text: String, numberPerPage: Int) {
        
        Products.getListProducts(numberOfItems: numberPerPage) { [weak self] success, listProducts, error in
            if success {
                guard let self = self, let listProducts = listProducts else {return}
                if text.isEmpty {
                    self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProducts, text: text)
                    return
                }
                var listProductFilter = [ProductOfList]()
                listProductFilter = listProducts.filter({ productOfList in
                    print("\(productOfList.title ?? "") text: \(text) cumple: \((productOfList.title ?? "").contains(text.lowercased()))")
                    return (productOfList.title?.lowercased() ?? "").contains(text.lowercased())
                })
                
                self.listProductsViewToViewModel?.succesGetListProducts(listProducts: listProductFilter, text: text)
                return
                
            } else {
                controller.view.makeToast(error)
            }
        }
    }
    
    func getLocationData() {
        
        LocationsWS.getLocationProduct() {[weak self] successs, locationData, error in
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
    
    func getListFavoriteProductsIds() -> [ProductOfList] {
        return FavoriteDefault.getFavoriteProduct()
    }
    
    func addAndRemoveFavoriteId(result: ProductOfList) {
        FavoriteDefault.addFavoriteProduct(result: result)
    }
    
    func getListPage(listProducts: [ProductOfList]) -> [String] {
        
        
        return ["0...5", "0...10", "0...15", "all"]
    }
}
