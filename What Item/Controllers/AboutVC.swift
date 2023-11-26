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
    var predicted:String?
    var dismissed:(()->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        textView.text = ""
        titleLabel.text = "About \(predicted?.capitalized ?? "")"
        loadApi()
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissed?()
    }
    
    func loadApi() {
        if let word = self.predicted {
            DispatchQueue(label: "api", qos: .userInitiated).async {
                API.fetch(word: word, completion: {json in
                    DispatchQueue.main.async {
                        self.textView.text = json ?? "Error loading Wikipedia data for \(word)"
                    }
                })
            }
        }
    }

}

extension AboutVC {
    static func configure(word:String?, dismissed:(()->())?) -> AboutVC {
        let storybard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storybard.instantiateViewController(withIdentifier: "AboutVC") as! AboutVC
        vc.predicted = word
        vc.dismissed = dismissed
        return vc
    }
}
