//
//  SongViewController.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import UIKit
import FlatUIKit
import RealmSwift
import DropDown

class SongViewController: UIViewController {

    @IBOutlet var songTitleField: FUITextField!
    @IBOutlet var songArtistField: FUITextField!
    @IBOutlet var songAlbumField: FUITextField!
    @IBOutlet var genrePickerField: FUITextField!
    @IBOutlet var musicServiceField: FUITextField!
    @IBOutlet var addButton: FUIButton!

    var arryOfGenres = [String]()
    var arryOfServices = [String]()
    let realmManager = RealmManager.shared

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        addButton.buttonColor = UIColor.peterRiver()
        addButton.shadowColor = UIColor.belizeHole()
        addButton.shadowHeight = 3.0
        addButton.cornerRadius = 5.0
        addButton.setTitleColor(UIColor.clouds(), for: .normal)
        addButton.setTitleColor(UIColor.clouds(), for: .highlighted)
        
        // Load genres
        if let genres = realmManager.appRealm?.objects(Genre.self) {
            for g in genres {
                arryOfGenres.append(g.name)
            }
        }
        
        // Load music services
        if let services = realmManager.appRealm?.objects(MusicService.self) {
            for s in services {
                arryOfServices.append(s.name)
            }
        }
        
        // Config pickers
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genrePickerField.inputView = genrePickerView
        
        // Config pickers
        let musicPickerView = UIPickerView()
        musicPickerView.delegate = self
        musicServiceField.inputView = musicPickerView
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        
        songTitleField.text = ""
        songArtistField.text = ""
        songAlbumField.text = ""
        genrePickerField.text = ""
        musicServiceField.text = ""
        hideKeyboard()
    }

    func hideKeyboard() {
        songTitleField.resignFirstResponder()
        songArtistField.resignFirstResponder()
        songAlbumField.resignFirstResponder()
        genrePickerField.resignFirstResponder()
        musicServiceField.resignFirstResponder()
    }
}

extension SongViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerField.inputView {
            return arryOfGenres[row]
        } else {
            return arryOfServices[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerField.inputView {
            genrePickerField.text = arryOfGenres[row]
        } else {
            musicServiceField.text = arryOfServices[row]
        }
    }
}

extension SongViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerField.inputView {
            return arryOfGenres.count
        } else {
           return arryOfServices.count
        }
    }
}
