//
//  NewGame.swift
//  ex6Swift
//
//  Created by VuHongSon on 7/27/17.
//  Copyright © 2017 VuHongSon. All rights reserved.
//

import UIKit

class NewGame: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func btnNewGameDid(_ sender: Any) {
        let mainView = storyboard?.instantiateViewController(withIdentifier: "mainViewController") as! ViewController
        self.present(mainView, animated: true, completion: nil)
    }
}
