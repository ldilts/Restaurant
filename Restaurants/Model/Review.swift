//
//  Review.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Review: NSObject {
    var rating: Int!
    var text: String!
    var user: User!

    init(withJSON json: JSON) {
        if let rating = json["rating"].int {
            self.rating = rating
        }
        
        if let text = json["text"].string {
            self.text = text
        }
        
        if let user = json["user"].dictionaryObject  {
            self.user = User(withDictionary: user)
        }
    }
}
