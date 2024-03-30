//
//  CALayer.swift
//  What Item
//
//  Created by Misha Dovhiy on 30.03.2024.
//  Copyright © 2024 Misha Dovhiy. All rights reserved.
//

import QuartzCore
import UIKit

extension CALayer {
    func move(_ direction:UIRectEdge, value:CGFloat) {
        switch direction {
        case .top:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, 0, value, 0)
        case .left:
            self.transform = CATransform3DTranslate(CATransform3DIdentity, value, 0, 0)
        default:
            break
        }
    }
}
