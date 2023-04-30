//
//  DetailRecipesViewModel.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import Foundation
import UIKit
import Toast_Swift
class DetailPeoductsViewModel {
    var detailProductsViewToViewModel: DetailProductsViewToViewModel?
    init(detailProductsViewToViewModel: DetailProductsViewToViewModel) {
        self.detailProductsViewToViewModel = detailProductsViewToViewModel
    }
}
//MARK: -DetailRecipesViewModelToView
extension DetailPeoductsViewModel: DetailProductsViewModelToView {
    func getDetailProducts(controller: UIViewController, idProduct: Int) {
        Products.getDetailProduct(idProduct: idProduct) { [weak self] success, detailProducts, error in
            guard let self = self else {return}
            if success {
                guard let detailProducts = detailProducts else {return}
                self.detailProductsViewToViewModel?.succesGetDetailProduct(detailProduct: detailProducts)
            } else {
                controller.view.makeToast(error)
            }
        }
    }
}
