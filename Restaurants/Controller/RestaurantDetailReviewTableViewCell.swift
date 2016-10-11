//
//  RestaurantDetailReviewTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantDetailReviewTableViewCell: UITableViewCell {

    var review: Review! {
        didSet {
            self.configureUI()
        }
    }
    
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var reviewLabel: UILabel!
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.review = nil
        
        userImageView.image = nil
        usernameLabel.text = ""
        reviewLabel.text = ""
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        if let uReview = self.review {
            if let user = uReview.user {
                
                // Set user image
                if let imageURL = user.imageURL {
                    if let url = URL(string: imageURL) {
                        self.userImageView.af_setImage(withURL: url)
                    }
                }
                
                // Set user name
                self.usernameLabel.text = user.name ?? ""
            }
            
            self.reviewLabel.text = uReview.text ?? ""
        }
    }

}
