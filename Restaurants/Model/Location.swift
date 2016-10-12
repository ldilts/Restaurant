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
    
    init(withDictionary dictionary: [String: Any]) {
        if let address1 = dictionary["address1"] as? String {
            self.address1 = address1
        }
        
        if let address2 = dictionary["address2"] as? String {
            self.address2 = address2
        }
        
        if let address3 = dictionary["address3"] as? String {
            self.address3 = address3
        }
        
        if let city = dictionary["city"] as? String {
            self.city = city
        }
        
        if let state = dictionary["state"] as? String {
            self.state = state
        }
        
        if let country = dictionary["country"] as? String {
            self.country = country
        }
        
        if let zipCode = dictionary["zip_code"] as? String {
            self.zipCode = zipCode
        }
    }
}
