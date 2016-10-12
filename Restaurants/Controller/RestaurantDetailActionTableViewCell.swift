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
    
    // Images
    
    private let addressImageName: String = "Share Button Icon"
    private let phoneImageName: String = "Phone Button Icon"
    private let websiteImageName: String = "Web Button Icon"
    
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
    
    // MARK: - Actions
    
    @IBAction func actionButtonTapped(_ sender: UIButton) {
        if let uBusiness = business {
            if let cellType = self.actionType {
                switch cellType {
                case .address: break
                case .phone:
                    let phone = "tel://\(uBusiness.phone!)"
                    UIApplication.shared.open(URL(string: phone)!, options: [:], completionHandler: nil)
                    break
                case .website:
                    UIApplication.shared.open(uBusiness.url, options: [:], completionHandler: nil)
                    break
                default: break
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uBusiness = self.business {
            if let uActionType = self.actionType {
                switch uActionType {
                case .address:
                    self.titleLabel.text = uBusiness.location!.address1 ?? ""
                    if let image = UIImage(named: addressImageName) {
                        self.actionButton.setImage(image, for: .normal)
                    }
                    break
                case .phone:
                    self.titleLabel.text = uBusiness.phone ?? ""
                    if let image = UIImage(named: phoneImageName) {
                        self.actionButton.setImage(image, for: .normal)
                    }
                    break
                case .website:
                    self.titleLabel.text = "Business Website"
                    if let image = UIImage(named: websiteImageName) {
                        self.actionButton.setImage(image, for: .normal)
                    }
                    break
                default: break // Type not supported
                }
            }
        }
    }
    
}
