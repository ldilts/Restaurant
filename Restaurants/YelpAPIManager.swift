//
//  YelpAPIManager.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-06.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import Locksmith

class YelpAPIManager {
    
    static let sharedInstance = YelpAPIManager()
    
    private var clientID: String = "f_5n4I1NCxIOegJkX58CGg"
    private var clientSecret: String = "Kg5Xn4RWJuab87jx1obJVgpFJGbER3YsiHsyOYVIowf43cQOFJVzoA3ASG3Wrr1L"
    private var clientGrantType: String = "client_credentials"
    private let userAccount: String = "yelp"
    
    var token: String? {
        set {
            if let valueToSave = newValue {
                do {
                    try Locksmith.saveData(data: ["token": valueToSave], forUserAccount: userAccount)
                } catch {
                    NSLog("Failed to save token: \(error)")
                }
            } else {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
                } catch {
                    NSLog("Failed to remove token: \(error)")
                }
            }
        }
        
        get {
            if let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount) {
                if let token = dictionary["token"] as? String {
                    return token
                }
            }
            
            return nil
        }
    }
    
    // MARK: - Public Methods
    
    func hasToken() -> Bool {
        if let token = self.token {
            return !token.isEmpty
        }
        
        return false
    }
    
    func getToken(withCompletionHandler completion: @escaping (_ result: Bool) -> Void) {
        let parameters: Parameters = ["client_id" : clientID,
                                     "client_secret" : clientSecret,
                                     "grant_type" : clientGrantType]

        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                NSLog("Error calling POST on /oauth2/token")
                NSLog("\(response.result.error!)")
                completion(false)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let token = json["access_token"].string {
                    self.token = token
                    completion(self.hasToken())
                    return
                }
            }
            
            completion(false)
        }
    }
}
