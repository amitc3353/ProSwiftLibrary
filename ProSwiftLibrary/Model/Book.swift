//
//  Book.swift
//  ProSwiftLibrary
//
//  Created by Amit Chandel on 7/27/15.
//  Copyright (c) 2015 Amit Chandel. All rights reserved.
//

import UIKit
import ObjectMapper

//class Book {
//    
//    var author: String?
//    var categories: String?
//    var lastCheckedOut: String?
//    var lastCheckedOutBy: String?
//    var publisher: String?
//    var title: String?
//    var url: String?
//    
//    init(json: AnyObject) {
//        self.author = json["name"] as? String
//        self.categories = json["description"] as? String
//        self.lastCheckedOut = json["html_url"] as? String
//        self.lastCheckedOutBy = json["description"] as? String
//        self.publisher = json["html_url"] as? String
//        self.title = json["html_url"] as? String
//        self.url = json["url"] as? String
//    }
//}

class Book: Mappable {
    var author: String?
    var categories: String?
    var lastCheckedOut: String?
    var lastCheckedOutBy: String?
    var publisher: String?
    var title: String?
    var url: String?
    
    class func newInstance() -> Mappable {
        return Book()
    }
    
    // Mappable
    func mapping(map: Map) {
        author    <- map["author"]
        categories         <- map["categories"]
        lastCheckedOut      <- map["lastCheckedOut"]
        lastCheckedOutBy       <- map["lastCheckedOutBy"]
        publisher  <- map["publisher"]
        title  <- map["title"]
        url     <- map["url"]
    }
}