//
//  SuggestedSection.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import SwiftyJSON

class SuggestedSection: NSObject {
    var position: Int = 0
    var title: String = ""
    var category: Category!
    var businesses: [Business] = [Business]()
    
    //    init() {
    //    }
    
    // This is used with the mock custom service
    init(withJSON json: [String: Any]) {
        if let position = json["position"] as? Int {
            self.position = position
        }
        
        if let title = json["title"] as? String {
            self.title = title
        }
        
        if let category = json["category"] as? [String: Any] {
            self.category = Category(withJSON: category)
        }
    }
    
    //    init(withPosition position: Int,
    //         andTitle title: String,
    //         andBusinesses businesses: [Business]) {
    //
    //        self.position = position
    //        self.title = title
    //        self.businesses = businesses
    //    }
}
