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
    dynamic var name = ""
}

class Genre: Object {
    dynamic var name = ""
}

class Song: Object {
    dynamic var title = ""
    dynamic var artist = ""
    dynamic var album = ""
    dynamic var released: NSDate? = nil
    dynamic var genre: Genre?
    dynamic var serviceReleasedTo: MusicService?
    let duration = RealmOptional<Int>()
}
