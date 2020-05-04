//
//  ResultsVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 12.02.2020.
//  Copyright © 2020 Misha Dovhiy. All rights reserved.
//

import UIKit

class ResultsVC: UIViewController {
    
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textLabel: UILabel!
    let netBrain = NetworkingManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateUI()
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func updateUI() {
        
        if V.ifCorrect == true {
            titleLabel.text = "Well Done!"
            textLabel.text = "You've found a \(V.userWord)"
            titleLabel.textAlignment = .left
            textLabel.textAlignment = .left
        } else if V.ifCorrect == false {
            titleLabel.text = "Oh no!"
            textLabel.text = "Seems like it's not a \(V.userWord)\nIt looks like \(V.itemOnImage)"
            titleLabel.textAlignment = .right
            textLabel.textAlignment = .right
        }
        
        navigationBarStyle()
        netBrain.fetchURL(usersObject: V.userWord)
        aboutButton.setTitle("About \(V.userWord)", for: .normal)
    }
    
    func navigationBarStyle() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = Colors.background
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }

}
