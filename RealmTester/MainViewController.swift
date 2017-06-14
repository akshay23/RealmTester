//
//  MainViewController.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import UIKit
import FlatUIKit
import Realm
import RealmSwift

class MainViewController: UIViewController {

    let songVC = SongViewController()
    let detailsVC = DetailsViewController()
    let realm = RealmManager.shared.userRealm
    let searchController = UISearchController(searchResultsController: nil)
    var songsData = RealmManager.shared.userRealm?.objects(Song.self)
    var notificationToken: NotificationToken!
    var timer: DispatchSourceTimer?
    
    @IBOutlet var addSongButton: FUIButton!
    @IBOutlet var songsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        startTimer()
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)

        navigationItem.title = "Welcome to RealmTester"
        addSongButton.buttonColor = UIColor.turquoise()
        addSongButton.shadowColor = UIColor.greenSea()
        addSongButton.shadowHeight = 3.0
        addSongButton.cornerRadius = 5.0
        addSongButton.setTitleColor(UIColor.clouds(), for: .normal)
        addSongButton.setTitleColor(UIColor.clouds(), for: .highlighted)
        
        songsTable.backgroundColor = UIColor.clear
        songsTable.dataSource = self
        songsTable.delegate = self
        songsTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        songsTable.tableFooterView = UIView()
        
        searchController.searchResultsUpdater = self
        searchController.view.backgroundColor = UIColor.clear
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        songsTable.tableHeaderView = searchController.searchBar
        
        // Observe Results Notifications
        notificationToken = songsData?.addNotificationBlock(songsTable.updateTable)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        searchController.isActive = false
    }
    
    deinit {
        notificationToken?.stop()
        stopTimer()
    }
}

private extension MainViewController {
    func filterContent(forSearchText searchText: String) {
        let predicate = NSPredicate(format: "title CONTAINS %@ OR artist CONTAINS %@", searchText, searchText)
        songsData = realm?.objects(Song.self).filter(predicate)
        songsTable.reloadData()
    }
    
    func startTimer() {
        let queue = DispatchQueue(label: "com.actionman.RealmTester.timer")
        timer = DispatchSource.makeTimerSource(queue: queue)
        timer!.scheduleRepeating(deadline: .now() + 30, interval: .seconds(30))
        timer!.setEventHandler {
            do {
                // Init Realms in current thread
                let userRealm = try Realm(configuration: RealmManager.shared.userConfig)
                let appRealm = try Realm(configuration: RealmManager.shared.appConfig)

                // Start a new transaction
                userRealm.beginWrite()

                let newSong = Song()
                newSong.album = "The Score"
                newSong.artist = "Fugees"
                newSong.title = "Fu-Gee-La"
                newSong.genreID = appRealm.objects(Genre.self).filter(NSPredicate(format: "name = %@", "Hip-Hop"))[0].id
                newSong.musicServiceID = appRealm.objects(MusicService.self).filter(NSPredicate(format: "name = %@", "Spotify"))[0].id
                userRealm.create(Song.self, value: newSong, update: false)
                
                let newSong2 = Song()
                newSong2.album = "Uncut Dope"
                newSong2.artist = "Geto Boys"
                newSong2.title = "Damn It Feels Good To Be A Gangsta"
                newSong2.genreID = appRealm.objects(Genre.self).filter(NSPredicate(format: "name = %@", "Hip-Hop"))[0].id
                newSong2.musicServiceID = appRealm.objects(MusicService.self).filter(NSPredicate(format: "name = %@", "Tidal"))[0].id
                userRealm.create(Song.self, value: newSong2, update: false)
                
                // Commit transaction
                try userRealm.commitWrite()
            } catch let error {
                log.error(error)
            }
        }
        timer!.resume()
    }
    
    func stopTimer() {
        timer?.cancel()
        timer = nil
    }
}

extension MainViewController {
    @IBAction func addSont(_ sender: Any) {
        hideKeyboard()
        navigationController?.pushViewController(songVC, animated: true)
    }
}

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let songs = songsData {
            return songs.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "cell")
        if let songs = songsData {
            let s = songs[indexPath.row]
            cell.textLabel?.text = s.title
            cell.detailTextLabel?.text = s.artist
            cell.accessoryType = .disclosureIndicator
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete, let objectToDelete = songsData?[indexPath.row] {
            do {
                realm?.beginWrite()
                realm?.delete(objectToDelete)
                try realm?.commitWrite(withoutNotifying: [notificationToken])
                tableView.deleteRows(at: [indexPath], with: .automatic)
            } catch let error {
                log.error(error)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        detailsVC.song = songsData?[indexPath.row]
        navigationController?.pushViewController(detailsVC, animated: true)
    }
}

extension MainViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContent(forSearchText: searchController.searchBar.text!)
    }
}

extension UITableView {
    func updateTable<T>(changes: RealmCollectionChange<T>) {
        switch changes {
        case .initial:
            // Results are now populated and can be accessed without blocking the UI
            reloadData()
            break
        case .update(_, let deletions, let insertions, let modifications):
            // Query results have changed, so apply them to the UITableView
            beginUpdates()
            insertRows(at: insertions.map({ IndexPath(row: $0, section: 0) }),
                                  with: .automatic)
            deleteRows(at: deletions.map({ IndexPath(row: $0, section: 0)}),
                                  with: .automatic)
            reloadRows(at: modifications.map({ IndexPath(row: $0, section: 0) }),
                                  with: .automatic)
            endUpdates()
            break
        case .error(let error):
            log.error(error)
            break
        }
    }
}
