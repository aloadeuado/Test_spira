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
    
    var listRecipes: ListRecipes?
    var viewModel: ListRecipesViewModel?
    var isFavoriteRecipes = false
    var listFavoritesRecipes = [Result]()
    var selectIndexDefault = 0
    var selectIndexDefaultNumberPage = 0
    var textSeacrh = ""
    var isLoading = true
    var userData: UserData?
    var locationModel: LocationModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }


    func initComponent() {
        viewModel = ListRecipesViewModel(listRecipesViewToViewModel: self)
        isLoading = true
        recipesCollectionView.reloadData()
        viewModel?.getListRecipes(controller: self, text: "", offsetPage: 0, numberPerPage: 10)
        viewModel?.getTextFastSearch()
        viewModel?.getLocationData()
        searchBarView.delegate = self
        dateSelectedView.delegate = self
        namePageDateSelectedView.delegate = self
        dateSelectedView.loadViews()
        recipesCollectionView.register(RecipeCollectionViewCell.nib(), forCellWithReuseIdentifier: RecipeCollectionViewCell.identificador)
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
            if (((self.listRecipes?.results ?? []).isEmpty)) {
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
extension ListRecipesViewController: ListRecipesViewToViewModel {
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
    
    func succesGetListRecipes(listRecipes: ListRecipes, text: String) {
        self.listRecipes = listRecipes
        self.textSeacrh = text
        isLoading = false
        if (((self.listRecipes?.results ?? []).isEmpty)) {
            namePageDateSelectedView.isHidden = true
            emptyState.isHidden = false
            return
        }
        emptyState.isHidden = true
        namePageDateSelectedView.isHidden = false
        if !(self.listRecipes?.results?.isEmpty ?? false) && !self.textSeacrh.isEmpty {
            viewModel?.addTextFastSearch(text: text)
        }
        guard let listRecipes = self.listRecipes else {return}
        namePageDateSelectedView.textList = viewModel?.getListPage(listRecipes: listRecipes) ?? []
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
        viewModel?.getListRecipes(controller: self, text: text, offsetPage: 0, numberPerPage: 10)
    }
    
    func onClearText() {
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListRecipes(controller: self, text: "", offsetPage: 0, numberPerPage: 10)
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
        return listRecipes?.results?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if isLoading {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
                cell.showSkeletor()
                return cell
            }
        }
        if isFavoriteRecipes {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
                cell.hidSkeletor()
                if let listRecipes = listRecipes {
                    cell.setData(baseUrl: listRecipes.baseURI ?? "", result: listFavoritesRecipes[indexPath.row])
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
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: RecipeCollectionViewCell.identificador, for: indexPath) as? RecipeCollectionViewCell {
            cell.hidSkeletor()
            if let listRecipes = listRecipes, let result = listRecipes.results {
                cell.setData(baseUrl: listRecipes.baseURI ?? "", result: result[indexPath.row])
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
        
        if isFavoriteRecipes {
            DetailRecipesViewController.show(controller: self, result: listFavoritesRecipes[indexPath.row])
            return
        }
        if let listRecipes = listRecipes, let result = listRecipes.results {
            DetailRecipesViewController.show(controller: self, result: result[indexPath.row])
        }
        
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
            isLoading = true
            self.recipesCollectionView.reloadData()
            viewModel?.getListRecipes(controller: self, text: self.textSeacrh, offsetPage: (index * 10), numberPerPage: 10)
            
            return
        }
        self.selectIndexDefault = index
        selectIndexDefaultNumberPage = 0
        self.textSeacrh = text
        isLoading = true
        self.recipesCollectionView.reloadData()
        viewModel?.getListRecipes(controller: self, text: text, offsetPage: 0, numberPerPage: 10)
        
    }
    
    func dateSelectedView(didSelectIndex index: Int, text: String) {
        
    }
}
//MARK: -RecipeCollectionViewCellDelegate
extension ListRecipesViewController: RecipeCollectionViewCellDelegate {
    func onShowLocation(datum: Datum) {
        MapViewController.show(controller: self, datum: datum)
    }
    
    func onAddAndRemoveFavorite(result: Result) {
        viewModel?.addAndRemoveFavoriteId(result: result)
        listFavoritesRecipes = viewModel?.getListFavoriteREcipesIds() ?? []
        recipesCollectionView.reloadData()
    }
}
