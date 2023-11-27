//
//  CameraVC.swift
//  What Item
//
//  Created by Misha Dovhiy on 25.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit
import AVFoundation

class CameraVC: UIViewController {

    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var wikipediaButton: UIButton!

    private var cameraModel:CameraModel!
    var mlModel:MLImageModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraModel = .init(view: self.view)
        mlModel = .init(camera: cameraModel, vc: self)
        togglePrimaryButton(false, animated: false)
    }
    
    func mlCapture() {
        mlModel.capture(camera: cameraModel)
    }
    

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        cameraModel.updateFrame(self.view.frame)
    }
    
    func togglePrimaryButton(_ show:Bool, animated:Bool = true) {
        if animated {
            wikipediaButton.animate()
        }
        wikipediaButton.isHidden = !show
    }
    

    @IBAction func wikipediaPressed(_ sender: Any) {
        self.present(AboutVC.configure(word: predictionLabel.text), animated: true)
    }
    
    @IBAction func cameraPressed(_ sender: Any) {
        self.mlCapture()
    }
}

extension CameraVC:AVCapturePhotoCaptureDelegate {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        mlModel.photoOutput(output, didFinishProcessingPhoto: photo, error: error)
    }
}


extension CameraVC: MLImageModelProtocol {
    func detected(_ predicted:String?, image:UIImage?) {
        predictionLabel.text = predicted ?? "-"
        togglePrimaryButton(predicted != nil)
        
        self.present(ImagePreviewVC.configure(img: image), animated: true)
    }
    
}
