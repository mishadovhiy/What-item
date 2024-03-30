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

    @IBOutlet weak var selectedSegmentLabel: UILabel!
    @IBOutlet weak var settingsStackView: UIStackView!
    @IBOutlet weak var predictionLabel: UILabel!
    @IBOutlet weak var wikipediaButton: UIButton!

    private var cameraModel:CameraModel!
    var mlModel:MLImageModel!
    var haptic:Haptic!
    private let toggleSettingsAnimation = UIViewPropertyAnimator(duration: 0.4, curve: .easeInOut)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.haptic = .init()
        cameraModel = .init(view: self.view)
        mlModel = .init(camera: cameraModel, vc: self)
        loadUI()
    }
    
    func mlCapture() {
        toggleSettigsView(show: false)
        mlModel.capture(camera: cameraModel)
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        cameraModel.updateFrame(self.view.frame)
    }
    
    @objc func settingsSegmentChanged(_ sender:UIPanGestureRecognizer) {
        let translation = sender.translation(in: view)
        let currentY = settingsStackView.layer.frame.minY
        settingsStackView.layer.move(.top, value: translation.y + currentY)
        sender.setTranslation(.zero, in: view)
        switch sender.state {
        case .ended, .cancelled, .failed:
            let firstFrame = settingsStackView.subviews.first?.frame.height ?? 0
            self.toggleSettigsView(show: !(currentY <= firstFrame / -2))
        case .began:
            toggleSettingsAnimation.stopAnimation(true)
        default:
            break
        }
    }
    
    @IBAction func wikipediaPressed(_ sender: Any) {
        self.present(AboutVC.configure(word: predictionLabel.text), animated: true)
    }
    
    @IBAction func typeSegmentChanged(_ sender: UISegmentedControl) {
        mlModel.segmentedChanged(label: selectedSegmentLabel, newValue: sender.selectedSegmentIndex)
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
        haptic.vibrate()
        //test text detection
     //   self.present(ImagePreviewVC.configure(img: image), animated: true)
    }
}


fileprivate extension CameraVC {
    func loadUI() {
        togglePrimaryButton(false, animated: false)
        settingsStackView.superview?.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(settingsSegmentChanged(_:))))
        mlModel.segmentedChanged(label: selectedSegmentLabel, newValue: 0)
        toggleSettigsView(show: false, animated: false)
    }
    
    func togglePrimaryButton(_ show:Bool, animated:Bool = true) {
        if animated {
            wikipediaButton.animate()
        }
        wikipediaButton.isHidden = !show
    }
    
    final func toggleSettigsView(show:Bool, animated:Bool = true) {
        toggleSettingsAnimation.stopAnimation(true)
        if animated {
            toggleSettingsAnimation.addAnimations {
                self.performToggleSettingsView(show: show)
            }
            toggleSettingsAnimation.startAnimation()
        } else {
            performToggleSettingsView(show: show)
        }
    }
    
    func performToggleSettingsView(show:Bool) {
        let firstFrame = settingsStackView.subviews.first?.frame.height ?? 0
        self.settingsStackView.layer.move(.top, value: !show ? firstFrame / -1 : 0)
    }
}
