//
//  Coordinates.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import SwiftyJSON

typealias Coordinate = Double

class Coordinates: NSObject {
    var latitude: Coordinate!
    var longitude: Coordinate!
    
    init(withJSON json: JSON) {
        if let latitude = json["latitude"].double {
            self.latitude = latitude
        }
        
        if let longitude = json["longitude"].double {
            self.longitude = longitude
        }
    }
}
