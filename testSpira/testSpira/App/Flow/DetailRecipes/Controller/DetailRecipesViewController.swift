//
//  DetailRecipesViewController.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
import SkeletonView
class DetailRecipesViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var intrucctionsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var creditsLabel: UILabel!
    @IBOutlet weak var heigthIngredientsTableView: NSLayoutConstraint!
    
    var detailRecipes: ProductOfList?
    var result: ProductOfList?
    var viewModel: DetailRecipesViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }

    func initComponent() {
        viewModel = DetailRecipesViewModel(detailRecipesViewToViewModel: self)
        showSkeletor()
        viewModel?.getDetailRecipes(controller: self, idProduct: result?.id ?? 0)
    }
    
    @IBAction func closePressed(button: UIButton) {
        self.dismiss(animated: true)
    }
    
    static func show(controller: UIViewController, result: ProductOfList) {
        let detailRecipesViewController = DetailRecipesViewController(nibName: "DetailRecipesViewController", bundle: nil)
        detailRecipesViewController.result = result
        detailRecipesViewController.modalPresentationStyle = .overFullScreen
        controller.present(detailRecipesViewController, animated: true)
    }
    
    func showSkeletor() {
        imageView.layer.cornerRadius = 8
        titleLabel.layer.cornerRadius = 8
        intrucctionsLabel.layer.cornerRadius = 8
        descriptionLabel.layer.cornerRadius = 8
        creditsLabel.layer.cornerRadius = 8
        
        imageView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
        intrucctionsLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
        creditsLabel.showAnimatedGradientSkeleton()
    }
    
    func showHide() {
        imageView.layer.cornerRadius = 0
        titleLabel.layer.cornerRadius = 0
        intrucctionsLabel.layer.cornerRadius = 0
        descriptionLabel.layer.cornerRadius = 0
        creditsLabel.layer.cornerRadius = 0
        
        imageView.hideSkeleton()
        titleLabel.hideSkeleton()
        intrucctionsLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
        creditsLabel.hideSkeleton()
    }
}
//MARK: -DetailRecipesViewToViewModel
extension DetailRecipesViewController: DetailRecipesViewToViewModel {
    func succesGetDetailRecipe(detailRecipes: ProductOfList) {
        self.detailRecipes = detailRecipes
        showHide()
        guard let detailRecipes = self.detailRecipes else {
            return
        }
        imageView.sd_setImage(with: NSURL(string: detailRecipes.image ?? "") as URL?)
        titleLabel.text = detailRecipes.title ?? ""
        
        creditsLabel.text = detailRecipes.description
    }
    
    func showError(error: String) {
        
    }
    
    
}
