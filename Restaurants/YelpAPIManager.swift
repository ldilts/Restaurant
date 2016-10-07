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
//import SwiftKeychainWrapper
import Locksmith

class YelpAPIManager {
    
    static let sharedInstance = YelpAPIManager()
    private let userAccount: String = "yelp"
//    private let tokenKey: String = "yelp-token"
//    private let keychainWrapper = KeychainWrapper()
    
    var OAuthToken: String? {
        set {
            if let valueToSave = newValue {
                do {
                    try Locksmith.saveData(data: ["token": valueToSave], forUserAccount: userAccount)
                } catch {
                    NSLog("Failed to save token: \(error)")
                }
//                guard KeychainWrapper.standard.set(valueToSave, forKey: tokenKey) else {
//                    NSLog("Failed to save token")
//                    return
//                }
                
                addSessionHeader(key: "Authorization", value: "Bearer \(valueToSave)")
            } else {
                do {
                    try Locksmith.deleteDataForUserAccount(userAccount: userAccount)
                } catch {
                    NSLog("Failed to remove token: \(error)")
                }
//                guard KeychainWrapper.standard.removeObject(forKey: tokenKey) else {
//                    NSLog("Failed to remove token")
//                    return
//                }
                
                removeSessionHeaderIfExists(key: "Authorization")
            }
        }
        
        get {
            if let dictionary = Locksmith.loadDataForUserAccount(userAccount: userAccount) {
                if let token = dictionary["token"] as? String {
                    return token
                }
            }
            removeSessionHeaderIfExists(key: "Authorization")
            return nil

//            guard let token = KeychainWrapper.standard.string(forKey: tokenKey) else {
//                removeSessionHeaderIfExists(key: "Authorization")
//                return nil
//            }
//
//            return token
        }
    }
    
    private var clientID: String = "f_5n4I1NCxIOegJkX58CGg"
    private var clientSecret: String = "Kg5Xn4RWJuab87jx1obJVgpFJGbER3YsiHsyOYVIowf43cQOFJVzoA3ASG3Wrr1L"
    private var clientGrantType: String = "client_credentials"
    
    // handlers for the OAuth process
    // stored as vars since sometimes it requires a round trip to safari which
    // makes it hard to just keep a reference to it
    var OAuthTokenCompletionHandler:((Error?) -> Void)?
    
    // MARK: - Public Methods
    
    func hasOAuthToken() -> Bool {
        if let token = self.OAuthToken {
            return !token.isEmpty
        }
        
        return false
    }
    
    func startOAuth2Login(withCompletionHandler completion: @escaping (_ result: Bool) -> Void) {
        let parameters: Parameters = ["client_id" : clientID,
                                     "client_secret" : clientSecret,
                                     "grant_type" : clientGrantType]

        Alamofire.request("https://api.yelp.com/oauth2/token", method: .post, parameters: parameters).responseJSON { (response) in
            
            guard response.result.isSuccess else {
                print("Error calling POST on /oauth2/token")
                print(response.result.error!)
                completion(false)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let token = json["access_token"].string {
                    self.OAuthToken = token
                    print("The token is: " + token)
                    completion(self.hasOAuthToken())
                    return
                }
            }
            
            completion(false)
        }
    }
    
    // MARK: - Private Actions
    
    private func addSessionHeader(key: String, value: String) {
        let manager = Alamofire.SessionManager.default
        
        if var sessionHeaders = manager.session.configuration.httpAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders[key] = value
            manager.session.configuration.httpAdditionalHeaders = sessionHeaders
        } else {
            manager.session.configuration.httpAdditionalHeaders = [key: value]
        }
    }
    
    private func removeSessionHeaderIfExists(key: String) {
        let manager = Alamofire.SessionManager.default
        
        if var sessionHeaders = manager.session.configuration.httpAdditionalHeaders as? Dictionary<String, String> {
            sessionHeaders.removeValue(forKey: key)
            manager.session.configuration.httpAdditionalHeaders = sessionHeaders
        }
    }
}
