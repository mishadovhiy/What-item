//
//  ImagePreviewVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit

class ImagePreviewVC:SuperVC {
    
    @IBOutlet weak var imageView: UIImageView!
    weak var image:UIImage?
    let textMLModel:DetectText = .init()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
     //   image = nil
        self.detectText()
    }

    
    private func detectText(img:UIImage? = nil) {
        if let img = img {
            imageView.image = img
        }
        textMLModel.recognize(img: self.imageView, vcView: self.view)
    }
    
    @IBAction func toPhotoLibraryPressed(_ sender: Any) {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        DispatchQueue.main.async {
            self.present(imgPicker, animated: true)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        print("gerfeadwef")
        self.view.subviews.forEach {
            if $0.contains(touches),
               $0.layer.name != nil
            {
                print($0.layer.name)
            }
        }
    }
}

extension ImagePreviewVC:UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let selected = (info[.editedImage] as? UIImage)
        else { return }
        picker.dismiss(animated: true)
     //   let nav = UINavigationController(rootViewController: ImagePreviewVC.configure(img: selected))
       // self.present(nav, animated: true)
        self.detectText(img: selected)
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
