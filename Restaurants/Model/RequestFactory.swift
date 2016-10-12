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

typealias AutocompleteResult = (businesses: [Business], categories: [Category])

protocol Request {
    func fetchResults(usingParameters parameters: Parameters?,
                 andID id: String?,
                 andCompletion completion: @escaping (_ result: Any?) -> Void)
}

class SearchRequest: Request {
    func fetchResults(usingParameters parameters: Parameters?, andID id: String?, andCompletion completion: @escaping (Any?) -> Void) {
        
        guard let _: Parameters = parameters else {
            NSLog("Error: Parameters are required for search")
            return
        }
        
        Alamofire.request(Router.search(parameters: parameters!,
                                        page: 1)).responseJSON { (response) in
            guard response.result.isSuccess else {
                NSLog("Error calling GET on /businesses/search")
                NSLog("\(response.result.error!)")
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
    func fetchResults(usingParameters parameters: Parameters?, andID id: String?, andCompletion completion: @escaping (Any?) -> Void) {
        
        guard let _ : String = id else {
            NSLog("Error: ID is required for review request")
            return
        }
        
        Alamofire.request(Router.reviews(id: id!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                NSLog("Error calling GET on /businesses/{id}/reviews")
                NSLog("\(response.result.error!)")
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
    func fetchResults(usingParameters parameters: [String : Any]?, andID id: String?, andCompletion completion: @escaping (Any?) -> Void) {
        
        guard let _ : String = id else {
            NSLog("Error: ID is required for review request")
            return
        }
        
        Alamofire.request(Router.business(id: id!)).responseJSON { (response) in
            guard response.result.isSuccess else {
                NSLog("Error calling GET on /businesses/{id}")
                NSLog("\(response.result.error!)")
                completion(nil)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                completion(Business(withJSON: json))
            }
            
            completion(nil)
        }
    }
}

class AutocompleteRequest: Request {
    
    func fetchResults(usingParameters parameters: Parameters?,
                 andID id: String?,
                 andCompletion completion: @escaping (Any?) -> Void) {
        
        guard let _: Parameters = parameters else {
            NSLog("Error: Parameters are required for search")
            return
        }
        
        Alamofire.request(Router.autocomplete(parameters: parameters!))
            .responseJSON { (response) in
            
            guard response.result.isSuccess else {
                NSLog("Error calling GET on /autocomplete")
                NSLog("\(response.result.error!)")
                completion(nil)
                return
            }
            
            if let value = response.result.value {
                let json = JSON(value)
                
                var autocompleteResult: AutocompleteResult = (businesses: [Business](), categories: [Category]())
                
                if let businesses = json["businesses"].array {
                    
                    var result: [Business] = [Business]()
                    
                    for business in businesses {
                        result.append(Business(withJSON: business))
                    }
                    
                    autocompleteResult.businesses = result
                }
                
                if let categories = json["categories"].array {
                    var result: [Category] = [Category]()
                    
                    for category in categories {
                        result.append(Category(withJSON: category))
                    }
                    
                    autocompleteResult.categories = result
                }
                
                completion(autocompleteResult)
                return
            }
                
            completion(nil)
        }
        
    }
}

enum RequestType: Int {
    case Search = 1
    case Reviews
    case Business
    case Autocomplete
}

class RequestFactory {
    static func request(forType type: RequestType) -> Request? {
        
        switch type {
        case .Search: return SearchRequest()
        case .Reviews: return ReviewsRequest()
        case .Autocomplete: return AutocompleteRequest()
        case .Business: return BusinessRequest()
        }
    }
}

// MARK: - Router

enum Router: URLRequestConvertible {
    
    // TODO: Add offset parameter
    case search(parameters: Parameters, page: Int)
    case reviews(id: String)
    case autocomplete(parameters: Parameters)
    case business(id: String)
    
    static let baseURLString = "https://api.yelp.com/v3"
    static let perPage = 10
    
    var method: HTTPMethod {
        switch self {
        case .search, .reviews, .autocomplete, .business:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .search: return "/businesses/search"
        case .reviews(let id): return "/businesses/\(id)/reviews"
        case .autocomplete: return "/autocomplete"
        case .business(let id): return "/businesses/\(id)"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try Router.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
        urlRequest.httpMethod = method.rawValue
        // TODO: Unwrap token safely 
        urlRequest.setValue("Bearer \(YelpAPIManager.sharedInstance.token!)", forHTTPHeaderField: "Authorization")
        
        switch self {
        case .search(let parameters, _):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        case .autocomplete(let parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        default: break
        }
        
        return urlRequest
    }
}
