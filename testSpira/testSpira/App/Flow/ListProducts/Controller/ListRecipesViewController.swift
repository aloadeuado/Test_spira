//
//  ListRecipesViewController.swift
//  test_yape_ios
//
//  Created by iMac on 24/02/23.
//

import Foundation
import UIKit
import Toast_Swift
class ListRecipesViewController: UIViewController {
    @IBOutlet weak var recipesCollectionView: UICollectionView!
    @IBOutlet weak var searchBarView: SearchBarView!
    @IBOutlet weak var dateSelectedView: DateSelectedView!
    @IBOutlet weak var namePageDateSelectedView: DateSelectedView!
    @IBOutlet weak var emptyState: UIView!
    
    var listProducts: [ProductOfList]?
    var viewModel: ListProductsViewModel?
    var isFavoriteRecipes = false
    var listFavoritesRecipes = [ProductOfList]()
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
        recipesCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: "", numberPerPage: maxCount)
        viewModel?.getTextFastSearch()
        viewModel?.getLocationData()
        searchBarView.delegate = self
        dateSelectedView.delegate = self
        namePageDateSelectedView.delegate = self
        dateSelectedView.loadViews()
        recipesCollectionView.register(ProductCollectionViewCell.nib(), forCellWithReuseIdentifier: ProductCollectionViewCell.identificador)
        listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
    }
    
    @IBAction func chageValueSegment(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 1 {
            isFavoriteRecipes = true
            listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
            if ((listFavoritesRecipes.isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            recipesCollectionView.reloadData()
        } else {
            isFavoriteRecipes = false
            if (((self.listProducts ?? []).isEmpty)) {
                namePageDateSelectedView.isHidden = true
                emptyState.isHidden = false
                return
            }
            emptyState.isHidden = true
            namePageDateSelectedView.isHidden = false
            recipesCollectionView.reloadData()
        }
    }
}
//MARK: -ListRecipesViewToViewModel
extension ListRecipesViewController: ListProductsViewToViewModel {
    func successGetListText(locationModel: LocationModel) {
        self.locationModel = locationModel
        recipesCollectionView.reloadData()
    }
    
    func successGetListText(textModel: TextModel) {
        dateSelectedView.textList = textModel.data ?? []
        let index = dateSelectedView.textList.firstIndex { text1 in
            return text1 == self.textSeacrh
        }
        dateSelectedView.indexDefault = index ?? -1
        dateSelectedView.loadViews()
        self.recipesCollectionView.reloadData()
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
        self.recipesCollectionView.reloadData()
    }
    
    func showError(error: String) {
        self.view.makeToast(error)
    }
}
//MARK: -SearchBarViewDelegate
extension ListRecipesViewController: SearchBarViewDelegate {
    func onGetText(text: String) {
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: text, numberPerPage: maxCount)
    }
    
    func onClearText() {
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: "", numberPerPage: maxCount)
    }

}
//MARK: -UICollectionViewDataSource
extension ListRecipesViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isLoading {
            return 4
        }
        if isFavoriteRecipes {
            return listFavoritesRecipes.count
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
        if isFavoriteRecipes {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identificador, for: indexPath) as? ProductCollectionViewCell {
                cell.hidSkeletor()
                if let listProducts = listProducts {
                    cell.setData(result: listFavoritesRecipes[indexPath.row])
                    let isFavorite = viewModel?.getListFavoriteREcipesIds().first(where: { result1 in
                        return result1.id == listFavoritesRecipes[indexPath.row].id
                    }) != nil
                    cell.isFavorite = isFavorite
                    cell.datum = locationModel?.data?.data?.first(where: { datum in
                        datum.idRecipe == listFavoritesRecipes[indexPath.row].id
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
                let isFavorite = viewModel?.getListFavoriteREcipesIds().first(where: { result1 in
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
extension ListRecipesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if isLoading {
            return
        }
        
        /*if isFavoriteRecipes {
            DetailRecipesViewController.show(controller: self, result: listFavoritesRecipes[indexPath.row])
            return
        }
        if let listRecipes = listRecipes, let result = listRecipes.results {
            DetailRecipesViewController.show(controller: self, result: result[indexPath.row])
        }*/
        
    }
}
//MARK: -UICollectionViewDelegate
extension ListRecipesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,sizeForItemAt indexPath: IndexPath) -> CGSize{
        let width = ((self.recipesCollectionView.frame.width / 2) - 64)
        return CGSize(width: width, height: 350)
    }
}
//MARK: -DateSelectedViewDelegate
extension ListRecipesViewController: DateSelectedViewDelegate {
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
            self.recipesCollectionView.reloadData()
            viewModel?.getListProducts(controller: self, text: self.textSeacrh, numberPerPage: maxCount)
            
            return
        }
        self.selectIndexDefault = index
        selectIndexDefaultNumberPage = 0
        
        self.textSeacrh = text
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListProducts(controller: self, text: self.textSeacrh, numberPerPage: maxCount)
        
    }
    
    func dateSelectedView(didSelectIndex index: Int, text: String) {
        
    }
}
//MARK: -RecipeCollectionViewCellDelegate
extension ListRecipesViewController: ProductCollectionViewCellDelegate {
    func onShowLocation(datum: Datum) {
        MapViewController.show(controller: self, datum: datum)
    }
    
    func onAddAndRemoveFavorite(result: ProductOfList) {
        viewModel?.addAndRemoveFavoriteId(result: result)
        listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
        recipesCollectionView.reloadData()
    }
}
