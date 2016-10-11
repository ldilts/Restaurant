//
//  RestaurantDetailTitleTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class RestaurantDetailTitleTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.business = nil
        self.titleLabel.text = ""
        self.ratingLabel.text = ""
        self.categoryLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uBusiness = self.business {
            if let title = uBusiness.name {
                self.titleLabel.text = title
            }
            
            if let rating = uBusiness.rating {
                self.ratingLabel.text = "\(rating).0"
            }
            
            var categoryString: String = ""
            
            for category in uBusiness.categories {
                categoryString.append("\(category.title!) ")
            }
            
            self.categoryLabel.text = categoryString
        }
    }

}
