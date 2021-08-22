//
//  ImageCollectionViewCell.swift
//  LetsMeet
//
//  Created by MD Tanvir Alam on 22/8/21.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var collectionImageView: UIImageView!
    @IBOutlet weak var cityCountryLabel: UILabel!
    @IBOutlet weak var nameAgeLabel: UILabel!
    @IBOutlet weak var backGroundPlaceHolder: UIView!
    
    let gradientLayer = CAGradientLayer()
    var indexPath:IndexPath!
    
    override func awakeFromNib() {
        collectionImageView.layer.cornerRadius = 5
        collectionImageView.clipsToBounds = true
    }
    
    override func draw(_ rect: CGRect) {
        if indexPath.row == 0{
            backGroundPlaceHolder.isHidden = false
            setupGradientBackGround()
        }else{
            backGroundPlaceHolder.isHidden = true
        }
    }
    
    func setUpcell(image:UIImage, countryCity:String, nameAge:String, indexpath:IndexPath){
        self.indexPath = indexpath
        collectionImageView.image = image
        
        cityCountryLabel.text = indexpath.row == 0 ? countryCity : ""
        nameAgeLabel.text = indexpath.row == 0 ? nameAge : ""
    }
    
    func setupGradientBackGround(){
        gradientLayer.removeFromSuperlayer()
        let colorTop = UIColor.clear.cgColor
        let colorBottom = UIColor.black.cgColor
        gradientLayer.colors = [colorTop,colorBottom]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.cornerRadius = 5
        gradientLayer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        gradientLayer.frame = self.backGroundPlaceHolder.bounds
        self.backGroundPlaceHolder.layer.insertSublayer(gradientLayer, at: 0)
    }
}
