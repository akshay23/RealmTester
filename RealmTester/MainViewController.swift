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
    let realm = RealmManager.shared.userRealm
    let searchController = UISearchController(searchResultsController: nil)
    var songsData = RealmManager.shared.userRealm?.objects(Song.self)
    var notificationToken: NotificationToken!
    
    @IBOutlet var addSongButton: FUIButton!
    @IBOutlet var songsTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    }
}

private extension MainViewController {
    func filterContent(forSearchText searchText: String) {
        let predicate = NSPredicate(format: "title CONTAINS %@ OR artist CONTAINS %@", searchText, searchText)
        songsData = realm?.objects(Song.self).filter(predicate)
        songsTable.reloadData()
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
