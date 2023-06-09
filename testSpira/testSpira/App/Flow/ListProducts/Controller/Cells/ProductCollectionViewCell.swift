//
//  ProductCollectionViewCell.swift
//  test_empowermentlabs
//
//  Created by iMac on 10/02/23.
//

import UIKit
import SDWebImage
import SkeletonView
protocol ProductCollectionViewCellDelegate: AnyObject {
    func onAddAndRemoveFavorite(result: ProductOfList)
    func onShowLocation(datum: Datum)
}
class ProductCollectionViewCell: UICollectionViewCell {

    static let  identificador = "ProductCollectionViewCell"
    static func nib() -> UINib  {   return UINib(nibName: "ProductCollectionViewCell", bundle: Bundle(for: ProductCollectionViewCell.self))  }
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var favoriteActiveImageView: UIImageView!
    @IBOutlet weak var favoriteInactiveImageView: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var locationButton: UIButton!
    
    var delegate: ProductCollectionViewCellDelegate?
    var result: ProductOfList?
    var datum: Datum?
    var isFavorite: Bool = false {
        didSet{
            if isFavorite {
                favoriteActiveImageView.isHidden = false
                favoriteInactiveImageView.isHidden = true
            } else {
                favoriteActiveImageView.isHidden = true
                favoriteInactiveImageView.isHidden = false
            }
        }
    }
    var isLocationExist: Bool = false {
        didSet{
            if isLocationExist {
                locationButton.isHidden = false
            } else {
                locationButton.isHidden = true
            }
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setData(result: ProductOfList) {
        self.result = result
        imageView.sd_setImage(with: URL(string: (result.image ?? "")))
        titleLabel.text = result.title
        subTitleLabel.text = result.description
    }
    
    @IBAction func favoriteOnPressed(button: UIButton) {
        if let result = self.result {
            delegate?.onAddAndRemoveFavorite(result: result)
        }
        
    }
    
    @IBAction func locationOnPressed(button: UIButton) {
        if let datum = datum {
            delegate?.onShowLocation(datum: datum)
        }
        
    }
    
    func showSkeletor(){
        self.imageView.layer.cornerRadius = 8
        self.favoriteActiveImageView.layer.cornerRadius = 8
        self.favoriteInactiveImageView.layer.cornerRadius = 8
        self.titleLabel.layer.cornerRadius = 8
        self.subTitleLabel.layer.cornerRadius = 8
        
        self.imageView.showAnimatedGradientSkeleton()
        self.favoriteActiveImageView.showAnimatedGradientSkeleton()
        self.favoriteInactiveImageView.showAnimatedGradientSkeleton()
        self.titleLabel.showAnimatedGradientSkeleton()
        self.subTitleLabel.showAnimatedGradientSkeleton()
    }
    
    func hidSkeletor(){
        self.imageView.layer.cornerRadius = 0
        self.favoriteActiveImageView.layer.cornerRadius = 0
        self.favoriteInactiveImageView.layer.cornerRadius = 0
        self.titleLabel.layer.cornerRadius = 0
        self.subTitleLabel.layer.cornerRadius = 0
        self.imageView.hideSkeleton()
        self.favoriteActiveImageView.hideSkeleton()
        self.favoriteInactiveImageView.hideSkeleton()
        self.titleLabel.hideSkeleton()
        self.subTitleLabel.hideSkeleton()
    }
}
