//
//  SearchResultRestaurantTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import AlamofireImage

class SearchResultRestaurantTableViewCell: UITableViewCell {
    
    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    
    var business: Business! {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - Life cycle

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    // MARK: - Helper Methods
    
    private func configureUI() {
        if let _ = self.business {
            
            // Set image
            if let imageURL = self.business.imageURL {
                if let url = URL(string: imageURL) {
                    self.previewImageView
                        .af_setImage(withURL: url,
                                     imageTransition: .crossDissolve(0.2))
                }
            }
            
            self.titleLabel.text = self.business!.name ?? ""
            
            
            // Business Category
            var categoryString: String = ""
            
            for category in business!.categories {
                categoryString.append("\(category.title!) ")
            }
            
            self.detailLabel.text = categoryString
            
        }
    }
}
