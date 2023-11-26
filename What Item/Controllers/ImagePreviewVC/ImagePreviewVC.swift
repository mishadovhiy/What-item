//
//  ImagePreviewVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

class ImagePreviewVC:UIViewController {
    
    @IBOutlet weak var imageView: UIImageView!
    weak var image:UIImage?
    let textMLModel:DetectText = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
   //     imageView.image = image
        image = nil
        textMLModel.recognize(img: self.imageView)
    }
    
    
}

extension ImagePreviewVC {
    static func configure(img:UIImage?) -> ImagePreviewVC {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "ImagePreviewVC") as! ImagePreviewVC
        vc.image = img
        return vc
    }
}
