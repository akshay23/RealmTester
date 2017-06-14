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

class SongViewController: UIViewController {

    @IBOutlet var songTitleField: FUITextField!
    @IBOutlet var songArtistField: FUITextField!
    @IBOutlet var songAlbumField: FUITextField!
    @IBOutlet var genrePickerField: FUITextField!
    @IBOutlet var musicServiceField: FUITextField!
    @IBOutlet var addButton: FUIButton!

    var currentGenreID: String?
    var currentServiceID: String?
    
    let realmManager = RealmManager.shared
    let genres = RealmManager.shared.appRealm?.objects(Genre.self)
    let services = RealmManager.shared.appRealm?.objects(MusicService.self)

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tapRecognizer)
        
        addButton.isEnabled = false
        addButton.buttonColor = UIColor.peterRiver()
        addButton.shadowColor = UIColor.belizeHole()
        addButton.shadowHeight = 3.0
        addButton.cornerRadius = 5.0
        addButton.setTitleColor(UIColor.clouds(), for: .normal)
        addButton.setTitleColor(UIColor.clouds(), for: .highlighted)
        
        // Config pickers
        let genrePickerView = UIPickerView()
        genrePickerView.delegate = self
        genrePickerField.inputView = genrePickerView
        
        // Config pickers
        let musicPickerView = UIPickerView()
        musicPickerView.delegate = self
        musicServiceField.inputView = musicPickerView
        
        // Text chagnge nfns
        songTitleField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        songArtistField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        songAlbumField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        songTitleField.becomeFirstResponder()
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
    
    func textDidChange(textField: UITextField) {
        addButton.isEnabled = !songTitleField.text!.isEmpty && !songArtistField.text!.isEmpty && !songAlbumField.text!.isEmpty
        
        if genrePickerField.text!.isEmpty {
            currentGenreID = nil
        }
        
        if musicServiceField.text!.isEmpty {
            currentServiceID = nil
        }
    }
    
    @IBAction func addSong(_ sender: Any) {
        if let r = realmManager.userRealm {
            do {
                try r.write {
                    let newSong = Song()
                    newSong.album = songAlbumField.text!
                    newSong.artist = songArtistField.text!
                    newSong.title = songTitleField.text!
                    newSong.genreID = currentGenreID
                    newSong.musicServiceID = currentServiceID
                    r.add(newSong)
                }
            } catch let error as NSError {
                log.error(error)
            }
        }
        
        navigationController?.popViewController(animated: true)
    }
}

extension SongViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == genrePickerField.inputView {
            return genres?[row].name
        } else {
            return services?[row].name
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == genrePickerField.inputView {
            genrePickerField.text = genres?[row].name
            currentGenreID = genres?[row].id
        } else {
            musicServiceField.text = services?[row].name
            currentServiceID = services?[row].id
        }
    }
}

extension SongViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == genrePickerField.inputView {
            return (genres?.count)!
        } else {
            return (services?.count)!
        }
    }
}
