//
//  FeaturedCategory.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation

struct FeaturedCategory {
    
    let title: String!
    let detail: String!
    let category: Category!
    
    init(withTitle title: String,
         andDetail detail: String,
         andCategory category: Category) {
        
        self.title = title
        self.detail = detail
        self.category = category
    }
    
}
