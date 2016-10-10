//
//  RestaurantCollectionViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class RestaurantCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - life cycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
        self.detailLabel.text = ""
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let _ = self.business {
            // Business name
            self.titleLabel.text = self.business!.name ?? ""
            
            // Business Category
            var categoryString: String = ""
            
            for category in business!.categories {
                categoryString.append("\(category.title!) ")
            }
            
            self.detailLabel.text = categoryString
            
            // Business Image
            if let imageURL = business!.imageURL {
                Alamofire.request(imageURL).responseImage { response in
                    if let image = response.result.value {
                        self.previewImageView.image = image
                    }
                }
            }
        }
    }
}
