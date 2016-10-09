//
//  Category.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import SwiftyJSON

public struct Category {

    var alias: String!
    var title: String!
    
    init(withJSON json: JSON) {
        if let alias = json["alias"].string {
            self.alias = alias
        }
        
        if let title = json["title"].string {
            self.title = title
        }
    }
}
