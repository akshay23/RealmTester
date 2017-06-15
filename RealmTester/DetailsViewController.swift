//
//  DetailsViewController.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/14/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import UIKit
import FlatUIKit
import RealmSwift

class DetailsViewController: UIViewController {
    
    var song: Song!
    let realm = RealmManager.shared.userRealm
    let genres = RealmManager.shared.appRealm?.objects(Genre.self)
    let services = RealmManager.shared.appRealm?.objects(MusicService.self)
    
    var currentGenreID: String?
    var currentServiceID: String?
    
    @IBOutlet var titleField: FUITextField!
    @IBOutlet var artistField: FUITextField!
    @IBOutlet var albumField: FUITextField!
    @IBOutlet var genreField: FUITextField!
    @IBOutlet var serviceField: FUITextField!
    @IBOutlet var updateButton: FUIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        updateButton.buttonColor = UIColor.peterRiver()
        updateButton.shadowColor = UIColor.belizeHole()
        updateButton.shadowHeight = 3.0
        updateButton.cornerRadius = 5.0
        updateButton.setTitleColor(UIColor.clouds(), for: .normal)
        updateButton.setTitleColor(UIColor.clouds(), for: .highlighted)
        
        // Config pickers
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genreField.inputView = genrePickerView
        
        // Config pickers
        let musicPickerView = UIPickerView()
        musicPickerView.delegate = self
        serviceField.inputView = musicPickerView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        titleField.text = song.title
        artistField.text = song.artist
        albumField.text = song.album
        
        if let genre = song.genreID {
            currentGenreID = genre
            genreField.text = genres?.filter("id = %@", genre)[0].name
        }
        
        if let service = song.musicServiceID {
            currentServiceID = service
            serviceField.text = services?.filter("id = %@", service)[0].name
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func hideKeyboard() {
        titleField.resignFirstResponder()
        albumField.resignFirstResponder()
        artistField.resignFirstResponder()
        genreField.resignFirstResponder()
        serviceField.resignFirstResponder()
    }
    
    @IBAction func updateSong(_ sender: Any) {
        do {
            try realm?.write {
                song.title = titleField.text!
                song.album = albumField.text!
                song.artist = artistField.text!
                
                if let genre = genreField.text, !genre.isEmpty {
                    song.genreID = genres?.filter("name = %@", genre)[0].id
                } else {
                    song.genreID = nil
                }
                
                if let service = serviceField.text, !service.isEmpty {
                    song.musicServiceID = services?.filter("name = %@", service)[0].id
                } else {
                    song.musicServiceID = nil
                }
                
                hideKeyboard()
                log.info("Updated song!")
                
                let alert = UIAlertController(title: "Updated", message: "Song was successfully updated", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                present(alert, animated: true, completion: nil)
            }
        } catch let error {
            log.error(error)
        }
    }
}

extension DetailsViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genreField.inputView {
            return genres?[row].name
        } else {
            return services?[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genreField.inputView {
            genreField.text = genres?[row].name
            currentGenreID = genres?[row].id
        } else {
            serviceField.text = services?[row].name
            currentServiceID = services?[row].id
        }
    }
}

extension DetailsViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genreField.inputView {
            return (genres?.count)!
        } else {
            return (services?.count)!
        }
    }
}
