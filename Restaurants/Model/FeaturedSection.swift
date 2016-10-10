//
//  FeaturedSection.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import SwiftyJSON

class FeaturedSection: SuggestedSection {
    
    var detail: String = ""
    var location: String = ""
    var color: UIColor = UIColor.lightGray
    
    // This is used with the mock custom service
    override init(withJSON json: [String: Any]) {
        super.init(withJSON: json)
        
        if let detail = json["detail"] as? String {
            self.detail = detail
        }
        
        if let location = json["location"] as? String {
            self.location = location
        }
        
        if let color = json["color"] as? Int {
            self.color = UIColor(netHex: color)
        }
    }
}
