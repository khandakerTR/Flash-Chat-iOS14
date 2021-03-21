//
//  WelcomeViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import  CLTypingLabel
class WelcomeViewController: UIViewController {

    @IBOutlet weak var titleLabel: CLTypingLabel!
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = "⚡️Chotta Message" // using pod
        
//        let tittleText = "⚡️FlashChat"
//        titleLabel.text = ""
//        var indexOfTittle = 0.0
//        for letter in tittleText {
//            Timer.scheduledTimer(withTimeInterval: 0.1 * indexOfTittle, repeats: false) { (timer) in
//                self.titleLabel.text?.append(letter)
//            }
//            indexOfTittle += 1
//        }
       
    }
    

}
