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
    dynamic var vin = ""
    dynamic var wheels = 0
    dynamic var model = ""
    
    override static func primaryKey() -> String? {
        return "vin"
    }
}

class MovieTopic: Topic {
    dynamic var movieID = ""
    dynamic var duration = 0.0
    dynamic var released = 1990
    dynamic var rating = 0
    
    override static func primaryKey() -> String? {
        return "movieID"
    }
}

class FoodTopic: Topic {
    dynamic var foodID = ""
    dynamic var isDelicious = false
    dynamic var isFruit = false
    
    override static func primaryKey() -> String? {
        return "foodID"
    }
}

class AnyTopic: Object {
    dynamic var typeName: String = ""
    dynamic var primaryKey: String = ""
    
    // A list of all subclasses that this wrapper can store
    static let supportedClasses: [Topic.Type] = [
        FoodTopic.self,
        MovieTopic.self,
        CarTopic.self
    ]
    
    // Construct the type-erased payment method from any supported subclass
    convenience init(_ topic: Topic) {
        self.init()
        typeName = String(describing: type(of: topic))
        guard let primaryKeyName = type(of: topic).primaryKey() else {
            fatalError("`\(typeName)` does not define a primary key")
        }
        guard let primaryKeyValue = topic.value(forKey: primaryKeyName) as? String else {
            fatalError("`\(typeName)`'s primary key `\(primaryKeyName)` is not a `String`")
        }
        primaryKey = primaryKeyValue
    }
    
    // Dictionary to lookup subclass type from its name
    static let methodLookup: [String : Topic.Type] = {
        var dict: [String : Topic.Type] = [:]
        for method in supportedClasses {
            dict[String(describing: method)] = method
        }
        return dict
    }()
    
    // Use to access the *actual* PaymentMethod value, using `as` to upcast
    var value: Topic {
        guard let type = AnyTopic.methodLookup[typeName] else {
            fatalError("Unknown payment method `\(typeName)`")
        }
        guard let value = try! Realm().object(ofType: type, forPrimaryKey: primaryKey as AnyObject) else {
            fatalError("`\(typeName)` with primary key `\(primaryKey)` does not exist")
        }
        return value
    }
}
