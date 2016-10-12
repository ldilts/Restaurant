//
//  Business.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class Business: NSObject {
//    fileprivate var id: Int = 1 // fileprivate enables the extension to see this property
    
    var rating: Int!
    var price: String!
    var phone: String!
    var id: String!
    var categories: [Category] = [Category]()
    var reviewCount: Int!
    var name: String!
    var url: URL!
    var coordinates: Coordinates!
    var imageURL: String!
    var location: Location!
    var address: String!
    var photos: [String] = [String]()
    
    
    init(withJSON json: JSON) {
        
        if let rating = json["rating"].int {
            self.rating = rating
        }
        
        if let price = json["price"].string {
            self.price = price
        }
        
        if let phone = json["phone"].string {
            self.phone = phone
        }
        
        if let id = json["id"].string {
            self.id = id
        }
        
        if let categories = json["categories"].array {
            for category in categories {
                self.categories.append(Category(withJSON: category))
            }
        }
        
        if let reviewCount = json["review_count"].int {
            self.reviewCount = reviewCount
        }
        
        if let name = json["name"].string {
            self.name = name
        }
        
        if let urlString = json["url"].string {
            if let url = URL(string: urlString) {
                self.url = url
            }
        }
        
        if let coordinates = json["coordinates"].object as? JSON {
            self.coordinates = Coordinates(withJSON: coordinates)
        }
        
        if let imageURL = json["image_url"].string {
            self.imageURL = imageURL
        }
        
        if let location = json["location"].object as? JSON {
            self.location = Location(withJSON: location)
        }
        
        if let photos = json["photos"].arrayObject {
            for photo in photos {
                if let imageURL = photo as? String {
                    self.photos.append(imageURL)
                }
            }
        }
    }

}

//extension Business: URLConvertible {
//    static let baseURLString = "https://api.yelp.com/v3"
//    
//    func asURL() throws -> URL {
//        let urlString = Business.baseURLString + "/businesses/\(self.id)/"
//        return try urlString.asURL()
//    }
//}
