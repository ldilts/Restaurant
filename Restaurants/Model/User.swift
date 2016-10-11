//
//  User.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import SwiftyJSON

class User: NSObject {
    
    var name: String!
    var imageURL: String!

    init(withDictionary dictionary: [String: Any]) {
        if let name = dictionary["name"] as? String {
            self.name = name
        }
        
        if let imageURL = dictionary["image_url"] as? String {
            self.imageURL = imageURL
        }
    }
}
