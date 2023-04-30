//
//  DetailRecipesViewController.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
import SkeletonView
class DetailProductsViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var detailProducts: ProductOfList?
    var result: ProductOfList?
    var viewModel: DetailPeoductsViewModel?
    override func viewDidLoad() {
        super.viewDidLoad()
        initComponent()
        // Do any additional setup after loading the view.
    }

    func initComponent() {
        viewModel = DetailPeoductsViewModel(detailProductsViewToViewModel: self)
        showSkeletor()
        viewModel?.getDetailProducts(controller: self, idProduct: result?.id ?? 0)
    }
    
    @IBAction func closePressed(button: UIButton) {
        self.dismiss(animated: true)
    }
    
    static func show(controller: UIViewController, result: ProductOfList) {
        let detailProductsViewController = DetailProductsViewController(nibName: "DetailProductsViewController", bundle: nil)
        detailProductsViewController.result = result
        detailProductsViewController.modalPresentationStyle = .overFullScreen
        controller.present(detailProductsViewController, animated: true)
    }
    
    func showSkeletor() {
        imageView.layer.cornerRadius = 8
        titleLabel.layer.cornerRadius = 8
        descriptionLabel.layer.cornerRadius = 8
        
        imageView.showAnimatedGradientSkeleton()
        titleLabel.showAnimatedGradientSkeleton()
        descriptionLabel.showAnimatedGradientSkeleton()
    }
    
    func showHide() {
        imageView.layer.cornerRadius = 0
        titleLabel.layer.cornerRadius = 0
        descriptionLabel.layer.cornerRadius = 0
        
        imageView.hideSkeleton()
        titleLabel.hideSkeleton()
        descriptionLabel.hideSkeleton()
    }
}
//MARK: -DetailRecipesViewToViewModel
extension DetailProductsViewController: DetailProductsViewToViewModel {
    func succesGetDetailProduct(detailProduct: ProductOfList) {
        self.detailProducts = detailProduct
        showHide()
        guard let detailProducts = self.detailProducts else {
            return
        }
        imageView.sd_setImage(with: NSURL(string: detailProducts.image ?? "") as URL?)
        titleLabel.text = detailProducts.title ?? ""
        
        descriptionLabel.text = detailProducts.description
    }
    
    func showError(error: String) {
        
    }
    
    
}
