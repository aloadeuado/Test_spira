//
//  ListProductsViewController.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
import UIKit
import Toast_Swift
class ListProdcutsViewController: UIViewController {
    @IBOutlet weak var productsCollectionView: UICollectionView!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var dateSelectedView: DateSelectedView!
    @IBOutlet weak var namePageDateSelectedView: DateSelectedView!
    @IBOutlet weak var emptyState: UIView!
    
    var listProducts: [ProductOfList]?
    var viewModel: ListProductsViewModel?
    var isFavoriteProducts = false
    var listFavoritesProducts = [ProductOfList]()
    var selectIndexDefault = 0
    var selectIndexDefaultNumberPage = 0
    var textSeacrh = ""
    var isLoading = true
    var userData: UserData?
    var maxCount = 5
    var locationModel: LocationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }


    func initComponent() {
        viewModel = ListProductsViewModel(listProductsViewToViewModel: self)
        isLoading = true
        productsCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: "", numberPerPage: maxCount)
        viewModel?.getTextFastSearch()
        viewModel?.getLocationData()
        searchBarView.delegate = self
        dateSelectedView.delegate = self
        namePageDateSelectedView.delegate = self
        dateSelectedView.loadViews()
        productsCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.identificador)
        listFavoritesProducts = viewModel?.getListFavoriteProductsIds() ?? []
    }
    
    @IBAction func chageValueSegment(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 1 {
            isFavoriteProducts = true
            listFavoritesProducts = viewModel?.getListFavoriteProductsIds() ?? []
            if ((listFavoritesProducts.isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            productsCollectionView.reloadData()
        } else {
            isFavoriteProducts = false
            if (((self.listProducts ?? []).isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            productsCollectionView.reloadData()
        }
    }
}
//MARK: -ListProductsViewToViewModel
extension ListProdcutsViewController: ListProductsViewToViewModel {
    func successGetListText(locationModel: LocationModel) {
        self.locationModel = locationModel
        productsCollectionView.reloadData()
    }
    
    func successGetListText(textModel: TextModel) {
        dateSelectedView.textList = textModel.data ?? []
        let index = dateSelectedView.textList.firstIndex { text1 in
            return text1 == self.textSeacrh
        }
        dateSelectedView.indexDefault = index ?? -1
        dateSelectedView.loadViews()
        self.productsCollectionView.reloadData()
    }
    
    func succesGetListProducts(listProducts: [ProductOfList], text: String) {
        self.listProducts = listProducts
        self.textSeacrh = text
        isLoading = false
        if (((self.listProducts ?? []).isEmpty)) {
            namePageDateSelectedView.isHidden = true
            emptyState.isHidden = false
            return
        }
        emptyState.isHidden = true
        namePageDateSelectedView.isHidden = false
        if !(self.listProducts?.isEmpty ?? false) && !self.textSeacrh.isEmpty {
            viewModel?.addTextFastSearch(text: self.textSeacrh)
        }
        guard let listProducts = self.listProducts else {return}
        namePageDateSelectedView.textList = viewModel?.getListPage(listProducts: listProducts) ?? []
        namePageDateSelectedView.indexDefault = selectIndexDefaultNumberPage
        namePageDateSelectedView.loadViews()
        self.productsCollectionView.reloadData()
    }
    
    func showError(error: String) {
        self.view.makeToast(error)
    }
}
//MARK: -SearchBarViewDelegate
extension ListProdcutsViewController: SearchBarViewDelegate {
    func onGetText(text: String) {
        isLoading = true
        self.productsCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: text, numberPerPage: maxCount)
    }
    
    func onClearText() {
        isLoading = true
        self.productsCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: "", numberPerPage: maxCount)
    }

}
//MARK: -UICollectionViewDataSource
extension ListProdcutsViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 4
        }
        if isFavoriteProducts {
            return listFavoritesProducts.count
        }
        return listProducts?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
                cell.showSkeletor()
                return cell
            }
        }
        if isFavoriteProducts {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
                cell.hidSkeletor()
                if let listProducts = listProducts {
                    cell.setData(result: listFavoritesProducts[indexPath.row])
                    let isFavorite = viewModel?.getListFavoriteProductsIds().first(where: { result1 in
                        return result1.id == listFavoritesProducts[indexPath.row].id
                    }) != nil
                    cell.isFavorite = isFavorite
                    cell.datum = locationModel?.data?.data?.first(where: { datum in
                        datum.idRecipe == listFavoritesProducts[indexPath.row].id
                    })
                    cell.isLocationExist = cell.datum != nil
                }
                cell.delegate = self
                
                return cell
            }
        }
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
            cell.hidSkeletor()
            if let result = listProducts {
                cell.setData(result: result[indexPath.row])
                let isFavorite = viewModel?.getListFavoriteProductsIds().first(where: { result1 in
                    return result1.id == result[indexPath.row].id
                }) != nil
                cell.isFavorite = isFavorite
                cell.datum = locationModel?.data?.data?.first(where: { datum in
                    datum.idRecipe == result[indexPath.row].id
                })
                cell.isLocationExist = cell.datum != nil
            }
            cell.delegate = self
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    
}
//MARK: -UICollectionViewDataSource
extension ListProdcutsViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {
            return
        }
        
        if isFavoriteProducts {
            DetailProductsViewController.show(controller: self, result: listFavoritesProducts[indexPath.row])
            return
        }
        if let result = listProducts {
            DetailProductsViewController.show(controller: self, result: result[indexPath.row])
        }
        
    }
}
//MARK: -UICollectionViewDelegate
extension ListProdcutsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((self.productsCollectionView.frame.width / 2) - 64)
        return CGSize(width: width, height: 350)
    }
}
//MARK: -DateSelectedViewDelegate
extension ListProdcutsViewController: DateSelectedViewDelegate {
    func dateSelectedView(dateSelectedView: DateSelectedView, didSelectIndex index: Int, text: String) {
        if dateSelectedView == namePageDateSelectedView {
            selectIndexDefaultNumberPage = index
            switch index {
            case 0:
                maxCount = 5
                break
            case 1:
                maxCount = 10
                break
            case 2:
                maxCount = 15
                break
            case 3:
                maxCount = 150
                break
            default:
                maxCount = 5
            }
            isLoading = true
            self.productsCollectionView.reloadData()
            viewModel?.getListProducts(controller: self, text: self.textSeacrh, numberPerPage: maxCount)
            
            return
        }
        self.selectIndexDefault = index
        selectIndexDefaultNumberPage = 0
        
        self.textSeacrh = text
        isLoading = true
        self.productsCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: self.textSeacrh, numberPerPage: maxCount)
        
    }
    
    func dateSelectedView(didSelectIndex index: Int, text: String) {
        
    }
}
//MARK: -ProductCollectionViewCellDelegate
extension ListProdcutsViewController: ProductCollectionViewCellDelegate {
    func onShowLocation(datum: Datum) {
        MapViewController.show(controller: self, datum: datum)
    }
    
    func onAddAndRemoveFavorite(result: ProductOfList) {
        viewModel?.addAndRemoveFavoriteId(result: result)
        listFavoritesProducts = viewModel?.getListFavoriteProductsIds() ?? []
        productsCollectionView.reloadData()
    }
}
