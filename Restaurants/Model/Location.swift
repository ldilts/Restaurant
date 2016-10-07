//
//  Location.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import SwiftyJSON

class Location: NSObject {
    var address1: String!
    var address2: String!
    var address3: String!
    var city: String!
    var state: String!
    var country: String!
    var zipCode: String!
    
    init(withJSON json: JSON) {
        if let address1 = json["address1"].string {
            self.address1 = address1
        }
        
        if let address2 = json["address2"].string {
            self.address2 = address2
        }
        
        if let address3 = json["address3"].string {
            self.address3 = address3
        }
        
        if let city = json["city"].string {
            self.city = city
        }
        
        if let state = json["state"].string {
            self.state = state
        }
        
        if let country = json["country"].string {
            self.country = country
        }
        
        if let zipCode = json["zip_code"].string {
            self.zipCode = zipCode
        }
    }
}
