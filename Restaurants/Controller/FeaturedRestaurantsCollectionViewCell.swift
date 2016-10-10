//
//  FeaturedRestaurantsCollectionViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class FeaturedRestaurantsCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var titleBackgroundView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    @IBOutlet weak var imageViewOne: UIImageView!
    @IBOutlet weak var imageViewTwo: UIImageView!
    @IBOutlet weak var imageViewThree: UIImageView!
    @IBOutlet weak var imageViewFour: UIImageView!
    @IBOutlet weak var imageViewFive: UIImageView!
    @IBOutlet weak var imageViewSix: UIImageView!
    @IBOutlet weak var imageViewSeven: UIImageView!
    @IBOutlet weak var imageViewEight: UIImageView!
    
    @IBOutlet var imageViews: [UIImageView]!
    
    
    var featuredSection: FeaturedSection! {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.detailLabel.text = ""
        
        for imageView in self.imageViews {
            imageView.image = nil
        }
        
        self.featuredSection = nil
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        
        // Load images async
        if let _ = featuredSection {
        
            let businesses = featuredSection!.businesses
            
            for (index, imageView) in imageViews.enumerated() {
                if businesses.indices.contains(index) {
                    if let imageURL = businesses[index].imageURL {
                        if let url = URL(string: imageURL) {
                            imageView.af_setImage(withURL: url, imageTransition: .crossDissolve(0.2))
                        }
                    }
                }
            }
            
            self.titleLabel.text = featuredSection!.title
            self.detailLabel.text = featuredSection!.detail
            
            self.titleBackgroundView.backgroundColor = featuredSection!.color
        }
    }
}
