//
//  MainViewController.swift
//  RealmTester
//
//  Created by Akshay Bharath on 6/12/17.
//  Copyright © 2017 Actionman Inc. All rights reserved.
//

import UIKit
import FlatUIKit
import RealmSwift

class MainViewController: UIViewController {

    let songVC = SongViewController()
    
    @IBOutlet var addSongButton: FUIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSongButton.buttonColor = UIColor.turquoise()
        addSongButton.shadowColor = UIColor.greenSea()
        addSongButton.shadowHeight = 3.0
        addSongButton.cornerRadius = 5.0
        addSongButton.setTitleColor(UIColor.clouds(), for: .normal)
        addSongButton.setTitleColor(UIColor.clouds(), for: .highlighted)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

private extension MainViewController {

}

extension MainViewController {
    @IBAction func addSont(_ sender: Any) {
        navigationController?.pushViewController(songVC, animated: true)
    }
}
