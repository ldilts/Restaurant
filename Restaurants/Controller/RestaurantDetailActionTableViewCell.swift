//
//  RestaurantDetailActionTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class RestaurantDetailActionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var actionButton: UIButton!
    
    var business: Business!
    
    var actionType: RestaurantDetailCellType! {
        didSet {
            self.configureUI()
        }
    }
    
    // Titles
    
    private let addressTitle: String = "Address"
    private let phoneTitle: String = "Phone"
    private let websiteTitle: String = "Website"
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.business = nil
        self.actionType = nil
        
        self.titleLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uActionType = self.actionType {
            switch uActionType {
            case .address:
                self.titleLabel.text = addressTitle
                break
            case .phone:
                self.titleLabel.text = phoneTitle
                break
            case .website:
                self.titleLabel.text = websiteTitle
                break
            default: break // Type not supported
            }
        }
    }
    
}
