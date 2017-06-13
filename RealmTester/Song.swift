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
    dynamic var duration = 0.0
    dynamic var released = NSDate()
    dynamic var genre: Genre!
    dynamic var serviceReleasedTo: MusicService!
}
