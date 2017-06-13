//
//  Song.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import Foundation
import RealmSwift

class MusicService: Object {
    dynamic var id = ""
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Genre: Object {
    dynamic var id = ""
    dynamic var name = ""
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

class Song: Object {
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var album = ""
    dynamic var released: NSDate? = nil
    dynamic var genreID: String? = nil
    dynamic var musicServiceID: String? = nil
    dynamic var topic: AnyTopic?
    let duration = RealmOptional<Int>()
}
