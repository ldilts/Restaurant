//
//  CategoryHeaderCollectionReusableView.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class CategoryHeaderCollectionReusableView: UICollectionReusableView {
        
    @IBOutlet weak var titleLabel: UILabel!
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.titleLabel.text = ""
    }
    
}
