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
                 andID id: String?,
                 andCompletion completion: @escaping (_ result: [Any]?) -> Void)
}

class SearchRequest: Request {
    func perform(withParameters parameters: Parameters?, andID id: String?, andCompletion completion: @escaping ([Any]?) -> Void) {
        
        guard let _: Parameters = parameters else {
            NSLog("Error: Parameters are required for search")
            return
        }
        
        Alamofire.request(Router.search(parameters: parameters!,
                                        page: 1)).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error calling GET on /businesses/search")
                print(response.result.error!)
                completion(nil)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let businesses = json["businesses"].array {
                    
                    var result: [Business] = [Business]()
                    
                    for business in businesses {
                        result.append(Business(withJSON: business))
                    }
                    
                    completion(result)
                    return
                }
            }
                                            
            completion(nil)
        }
    }
}

class ReviewsRequest: Request {
    func perform(withParameters parameters: Parameters?, andID id: String?, andCompletion completion: @escaping ([Any]?) -> Void) {
        
        guard let _ : String = id else {
            NSLog("Error: ID is required for review request")
            return
        }
        
        Alamofire.request(Router.reviews(id: id!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                print("Error calling GET on /businesses/{id}/reviews")
                print(response.result.error!)
                completion(nil)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                if let reviews = json["reviews"].array {
                    
                    var result: [Review] = [Review]()
                    
                    for review in reviews {
                        result.append(Review(withJSON: review))
                    }
                    
                    completion(result)
                    return
                }
            }
            
            completion(nil)
        }
    }
}

class BusinessRequest: Request {
    func perform(withParameters parameters: [String : Any]?, andID: String?, andCompletion completion: @escaping ([Any]?) -> Void) {
        completion(nil) // TODO: Implement business request
    }
}

enum RequestType: Int {
    case Search = 1
    case Reviews = 2
    case Business
}

class RequestFactory {
    static func request(forType type: RequestType) -> Request? {
        
        switch type {
        case .Search: return SearchRequest()
        case .Reviews: return ReviewsRequest()
        default: return nil
        }
    }
}

// MARK: - Router

enum Router: URLRequestConvertible {
    
    // TODO: Add offset parameter
    case search(parameters: Parameters, page: Int)
    case reviews(id: String)
    
    static let baseURLString = "https://api.yelp.com/v3"
    static let perPage = 10
    
    var method: HTTPMethod {
        switch self {
        case .search, .reviews:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search: return "/businesses/search"
        case .reviews(let id): return "/businesses/\(id)/reviews"
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
