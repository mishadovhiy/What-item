//
//  MLImageModel.swift
//  What Item
//
//  Created by Misha Dovhiy on 25.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import AVFoundation
import UIKit
import CoreML
import Vision

class MLImageModel:NSObject {
    private let mlManager:MLModelManager
    private let delegate:MLImageModelProtocol
    private var selectedSegment:Int = 0
    
    init(camera:CameraModel, vc:UIViewController) {
        self.delegate = vc as! MLImageModelProtocol
        self.mlManager = .init()
        super.init()
    }
    
    func capture(camera:CameraModel) {
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat:[String:Any] = [
            kCVPixelBufferPixelFormatTypeKey as String:previewPixelType,
            kCVPixelBufferWidthKey as String: 160,
            kCVPixelBufferHeightKey as String: 160
        ]
        settings.previewPhotoFormat = previewFormat
        camera.output.capturePhoto(with: settings, delegate: delegate as! AVCapturePhotoCaptureDelegate)
    }

    func segmentedChanged(label:UILabel, newValue:Int) {
        self.selectedSegment = newValue
        label.text = newValue == 1 ? "CreateML trained animal model\nWill detect cat / dog / rabbit" : "CoreML model \nWill detect any object"
    }
}
extension MLImageModel {
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {

        guard let imgData = photo.fileDataRepresentation(),
              let image = UIImage(data:imgData),
              error == nil
        else {
            return
        }
        mlManager.detect(image: CIImage(image: image),
                         completion: {
            self.delegate.detected($0, image:image)
        }, mlType: selectedSegment)
    }

}


protocol MLImageModelProtocol {
    func detected(_ predicted:String?, image:UIImage?)
}


struct MLModelManager {
    func detect(image: CIImage?, completion:@escaping(_ detected:String?)->(), mlType:Int) {
        guard let model = self.model(mlType),
              let image = image
        else {
            completion(nil)
            return
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { 
                completion(nil)
                return
            }
            if let firstResults = results.first,
               let word = firstResults.identifier.components(separatedBy: ",").first
            {
                completion(word)
            }}
        
        let hendler = VNImageRequestHandler(ciImage: image)
        do {
            try? hendler.perform([request])
            
        } catch {
            print("Error performing image request: \(error.localizedDescription)")

        }        
    }
    
    private func model(_ mlType:Int) -> VNCoreMLModel? {
        if mlType == 1 {
            guard let modelConf = try?
                    animalsImages(configuration: MLModelConfiguration()),
                let model = try? VNCoreMLModel(for: modelConf.model) else {
                return nil
            }
            return model
        } else if mlType == 0 {
            guard let modelConf = try?
                    Inceptionv3(configuration: MLModelConfiguration()),
                let model = try? VNCoreMLModel(for: modelConf.model) else {
                return nil
            }
            return model
        } else {
            return nil
        }
    }
}
