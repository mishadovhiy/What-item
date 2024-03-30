//
//  UIView.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

extension UIView {
    func animate(_ duration:CFTimeInterval = 0.3, type:CATransitionType  = .fade) {
        let animation = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name:
                .linear)
        animation.type = type
        animation.duration = duration
        layer.add(animation, forKey: type.rawValue)
    }
}
