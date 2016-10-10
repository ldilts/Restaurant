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
    
    init() {
        alias = ""
        title = ""
    }
    
    init(withAlias alias: String, andTitle title: String) {
        self.alias = alias
        self.title = title
    }
    
    init(withJSON json: JSON) {
        if let alias = json["alias"].string {
            self.alias = alias
        }
        
        if let title = json["title"].string {
            self.title = title
        }
    }
    
    // This is needed to support the mocked custom service
    init(withJSON json: [String: Any]) {
        if let alias = json["alias"] as? String {
            self.alias = alias
        }
        
        if let title = json["title"] as? String {
            self.title = title
        }
    }
}
