//
//  RequestFactory.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

// MARK: - Factory

@objc protocol Request {
    func perform(withParameters parameters: Parameters?,
                       andCompletion completion: @escaping (_ result: Bool) -> Void)
}

class SearchRequest: Request {
    func perform(withParameters parameters: Parameters?, andCompletion completion: @escaping (Bool) -> Void) {
        
        guard let foo: Parameters = parameters else {
            NSLog("Error: Parameters are required for search")
            return
        }
        
        Alamofire.request(Router.search(parameters: foo,
                                        page: 1)).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error calling GET on /businesses/search")
                print(response.result.error!)
                completion(false)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let businesses = json["businesses"].array {
                    // TODO: Instantiate businesses from JSON
                    completion(true)
                    return
                }
            }
                                            
            completion(false)
        }
    }
}

class BusinessRequest: Request {
    func perform(withParameters parameters: [String : Any]?, andCompletion completion: @escaping (Bool) -> Void) {
        completion(false) // TODO: Implement business request
    }
}

enum RequestType: Int {
    case Search = 1
    case Business
}

class RequestFactory {
    static func request(forType type: RequestType) -> Request? {
        
        switch type {
        case .Search: return SearchRequest()
        default: return nil
        }
    }
}

// MARK: - Router

enum Router: URLRequestConvertible {
    
    // TODO: Add offset parameter
    case search(parameters: Parameters, page: Int)
    
    static let baseURLString = "https://api.yelp.com/v3"
    static let perPage = 10
    
    var method: HTTPMethod {
        switch self {
        case .search:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search:
            return "/businesses/search"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue("Bearer \(YelpAPIManager.sharedInstance.token!)", forHTTPHeaderField: "Authorization")
        
        switch self {
        case .search(let parameters, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default: break
        }
        
        return urlRequest
    }
}
