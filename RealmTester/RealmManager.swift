//
//  RealmManager.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

final class RealmManager {
    
    // Shared instance
    static let shared = RealmManager()
    
    // App's Realm instance
    var appConfig: Realm.Configuration!
    var appRealm: Realm?
    
    // User's Realm instance
    var userConfig: Realm.Configuration!
    var userRealm: Realm?
    
    private init() {
        initializeAppRealm()
        initializeUserRealm()
        populateGenres()
        populateMusicServices()
    }
    
    func printRealmPaths() {
        if let r = appRealm, let url = r.configuration.fileURL {
            log.info("App Realm path is \(url)")
        } else {
            log.error("Could not get app realm path")
        }

        if let r = userRealm, let url = r.configuration.fileURL {
            log.info("User Realm path is \(url)")
        } else {
            log.error("Could not get user realm path")
        }
    }
}

private extension RealmManager {
    func initializeAppRealm() {
        // Initialize app Realm schema
        appConfig = Realm.Configuration(
            fileURL: URL(fileURLWithPath: RLMRealmPathForFile("app.realm"), isDirectory: false),
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                //if (oldSchemaVersion < 1) { }
            },
            objectTypes: [Genre.self, MusicService.self]
        )
        
        // Init app realm
        do {
            try appRealm = Realm(configuration: appConfig)
        } catch let error as NSError {
            log.error(error)
        }
    }

    func initializeUserRealm() {
        // Initialize user Realm schema
        userConfig = Realm.Configuration(
            fileURL: URL(fileURLWithPath: RLMRealmPathForFile("user.realm"), isDirectory: false),
            schemaVersion: 0,
            migrationBlock: { migration, oldSchemaVersion in
                //if (oldSchemaVersion < 1) { }
            },
            objectTypes: [Song.self, Topic.self, CarTopic.self, FoodTopic.self, MovieTopic.self, AnyTopic.self]
        )
        
        // Init user realm
        do {
            try userRealm = Realm(configuration: userConfig)
        } catch let error as NSError {
            log.error(error)
        }
    }
    
    func populateGenres() {
        if let r = appRealm {
            if r.objects(Genre.self).count != 0 {
                do {
                    try r.write {
                        r.delete(r.objects(Genre.self))
                    }
                } catch let error as NSError {
                    log.error(error)
                }
            }
            
            do {
                try r.write {
                    let defaultGenres = ["Hip-Hop", "Rock", "Classical", "Pop", "Electronic", "Jazz"]
                    for genre in defaultGenres {
                        let newGenre = Genre()
                        newGenre.id = UUID().uuidString
                        newGenre.name = genre
                        r.add(newGenre)
                    }
                    log.info("Genres added to App Realm")
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
    
    func populateMusicServices() {
        if let r = appRealm {
            if r.objects(MusicService.self).count != 0 {
                do {
                    try r.write {
                        r.delete(r.objects(MusicService.self))
                    }
                } catch let error as NSError {
                    log.error(error)
                }
            }
            
            do {
                try r.write {
                    let defaultServices = ["Spotify", "🍏 Music", "Sound⛅️", "Tidal", "Amazon Prime 🎶"]
                    for service in defaultServices {
                        let newService = MusicService()
                        newService.id = UUID().uuidString
                        newService.name = service
                        r.add(newService)
                    }
                    log.info("Services added to App Realm")
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
    }
}
