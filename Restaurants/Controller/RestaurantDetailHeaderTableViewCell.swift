//
//  RestaurantDetailHeaderTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantDetailHeaderTableViewCell: UITableViewCell {

    @IBOutlet weak var previewImageView: UIImageView!
    
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
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uBusiness = self.business {
            if let imageURL = uBusiness.imageURL {
                if let url = URL(string: imageURL) {
                    self.previewImageView.af_setImage(withURL: url,
                                                      imageTransition: .crossDissolve(0.2))
                }
            }
        }
    }

}
