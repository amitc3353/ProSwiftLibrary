//
//  PLAPIManager.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/28/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import Alamofire

enum Router: URLRequestConvertible {
    
    case PostBook([String: AnyObject])
    case GetBooks
    case GetABook(String)
    case UpdateBook(String, [String: AnyObject])
    case DeleteBook(String)
    
    var method: Alamofire.Method {
        switch self {
        case .PostBook:
            return .POST
        case .GetBooks:
            return .GET
        case .GetABook:
            return .GET
        case .UpdateBook:
            return .PUT
        case .DeleteBook:
            return .DELETE
        }
    }
    
    var path: String {
        switch self {
        case .PostBook:
            return "/books/"
        case .GetBooks:
            return "/books"
        case .GetABook(let bookEndPoint):
            return "\(bookEndPoint)"
        case .UpdateBook(let bookEndPoint, _):
            return "\(bookEndPoint)"
        case .DeleteBook(let bookEndPoint):
            return "\(bookEndPoint)"
        }
    }
    
    var URLRequest: NSURLRequest {
        let URL:NSURL! = NSURL(string: kBaseURL)
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .PostBook(let parameters):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: parameters).0
        case .UpdateBook(_, let parameters):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: parameters).0
        default:
            return mutableURLRequest
        }
    }
}
