//
//  SuperVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

class SuperVC: UIViewController {
    
    var dismissed:(()->())?

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        dismissed?()
        dismissed = nil
    }
}
