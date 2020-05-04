//
//  AboutVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 16.02.2020.
//  Copyright © 2020 Misha Dovhiy. All rights reserved.
//

import UIKit

class AboutVC: UIViewController {
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBarStyle()
        textView.text = V.textHolder
        titleLabel.text = "About \(V.userWord.capitalized)"
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    
    func navigationBarStyle() {
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.navigationBar.barTintColor = Colors.background
        navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")

    }
    
    
}
