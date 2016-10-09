//
//  RestaurantCollectionViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

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
            self.titleLabel.text = self.business!.name ?? ""
        }
    }
}
