//
//  Topic.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/13/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import Foundation
import RealmSwift

// Abstract class
class Topic: Object {
    dynamic var name = ""
}

class CarTopic: Topic {
    dynamic var wheels = 0
    dynamic var model = ""
    dynamic var make = ""
    dynamic var vin = ""
    
    override static func primaryKey() -> String? {
        return "vin"
    }
}

class MovieTopic: Topic {
    dynamic var duration = 0.0
    dynamic var released = 1990
    dynamic var rating = 0
    dynamic var wikiArticle = ""
    
    override static func primaryKey() -> String? {
        return "wikiArticle"
    }
}

class FoodTopic: Topic {
    dynamic var isDelicious = false
    dynamic var isFruit = false
    dynamic var uniqueID = ""
    
    override static func primaryKey() -> String? {
        return "uniqueID"
    }
}
