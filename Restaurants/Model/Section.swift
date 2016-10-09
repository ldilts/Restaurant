//
//  Section.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation

class Section {
    var position: Int = 0
    var title: String = ""
    var businesses: [Business] = [Business]()
    
    init() {
    }
    
    init(withPosition position: Int,
         andTitle title: String,
         andBusinesses businesses: [Business]) {
        
        self.position = position
        self.title = title
        self.businesses = businesses
    }
}
