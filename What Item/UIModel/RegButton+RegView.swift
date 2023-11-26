//
//  RegButton+RegView.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

@IBDesignable
class RegView: UIView {
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}

@IBDesignable
class RegButton: UIButton {
    @IBInspectable var cornerRadius:CGFloat = 0 {
        didSet {
            self.layer.cornerRadius = cornerRadius
        }
    }
}


