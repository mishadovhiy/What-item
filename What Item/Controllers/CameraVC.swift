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
    var mlModel:MLImageModel!// = .init(camera: self.cameraModel, vc: self)

    var timerStopped:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cameraModel = .init(view: self.view)
        mlModel = .init(camera: cameraModel, vc: self)
//        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(4), execute: {
//          //  self.mlCapture()
////            Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
////                if !self.timerStopped {
////                    self.mlCapture()
////                }
////            }
//        })
        
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
        timerStopped = true
        self.present(AboutVC.configure(word: predictionLabel.text, dismissed: {
            self.timerStopped = false
        }), animated: true)
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
        
    //    self.present(ImagePreviewVC.configure(img: image), animated: true)
    }
    
}
