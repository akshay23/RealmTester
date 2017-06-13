//
//  MainViewController.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import UIKit
import RealmSwift
import FlatUIKit

class MainViewController: UIViewController {

    let songVC = SongViewController()
    let realm = try! Realm()
    
    @IBOutlet var addSongButton: FUIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSongButton.buttonColor = UIColor.turquoise()
        addSongButton.shadowColor = UIColor.greenSea()
        addSongButton.shadowHeight = 3.0
        addSongButton.cornerRadius = 5.0
        addSongButton.setTitleColor(UIColor.clouds(), for: .normal)
        addSongButton.setTitleColor(UIColor.clouds(), for: .highlighted)
        
        // Print out location of Realm db
        if let url = Realm.Configuration.defaultConfiguration.fileURL {
            print(url)
        }
        
        // Populate genres
        populateGenres()
        
        // Populate music services
        populateMusicServices()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension MainViewController {
    func populateGenres() {
        if realm.objects(Genre.self).count != 0 {
            do {
                try realm.write {
                    realm.delete(realm.objects(Genre.self))
                }
            } catch {}
        }

        do {
            try realm.write {
                let defaultGenres = ["Hip-Hop", "Rock", "Classical", "Pop", "Electronic", "Jazz"]
                for genre in defaultGenres {
                    let newGenre = Genre()
                    newGenre.name = genre
                    self.realm.add(newGenre)
                }
            }
        } catch {
            print("Coult not save to Realm")
        }
    }
    
    func populateMusicServices() {
        if realm.objects(MusicService.self).count != 0 {
            do {
                try realm.write {
                    realm.delete(realm.objects(MusicService.self))
                }
            } catch {}
        }
        
        do {
            try realm.write {
                let defaultServices = ["Spotify", "🍏 Music", "Sound⛅️", "Tidal", "Amazon Prime 🎶"]
                for service in defaultServices {
                    let newService = MusicService()
                    newService.name = service
                    self.realm.add(newService)
                }
            }
        } catch {
            print("Coult not save to Realm")
        }
    }

}

extension MainViewController {
    @IBAction func addSont(_ sender: Any) {
        navigationController?.pushViewController(songVC, animated: true)
    }
}
