//
//  DetectText.swift
//  What Item
//
//  Created by Misha Dovhiy on 26.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import UIKit
import Vision

class DetectText {
    static let backgroundAlphaComp:CGFloat = 0.2
    func recognize(img:UIImageView, vcView:UIView) {
        DispatchQueue(label: "ml", qos: .userInitiated).async {
            let request = VNDetectTextRectanglesRequest { request, error in
                guard let obthervations = request.results as? [VNTextObservation] else { 
                    print("nooo text")
                    return }
                DispatchQueue.main.async {
                    var i = 0
                    self.addShapes(observation: obthervations, imgView: img).forEach { layer in
                        let view = UIView(frame: layer.frame)
                        let box = obthervations[i]

                        if let gestureImage = self.cropImage(for: box, in: img.image!) {
                            self.imgString(from: gestureImage) { str in
                                print("ergwfeadsADSF")
                                view.isUserInteractionEnabled = true
                                view.backgroundColor = .red.withAlphaComponent(DetectText.backgroundAlphaComp)
                                view.layer.name = str
                                view.addGestureRecognizer(UITapGestureRecognizer(target: nil, action: #selector(self.layerPressed(_:))))
                                
                           //     layer.name = str
                            }
                        }
                        
                        img.layer.addSublayer(layer)

                        vcView.addSubview(view)
                        i += 1
                    }
                }
                
                
            }
            DispatchQueue.main.async {
                if let image = img.image,
                   let cgImage = image.cgImage {
                    let handler = VNImageRequestHandler(cgImage: cgImage)
                    guard let _ = try? handler.perform([request]) else {
                        print("errorperform VNDetectTextRectanglesRequest")
                        return
                    }
                }
            }
        }
    }
    
    private func cropImage(for observation: VNTextObservation, in image: UIImage) -> UIImage? {
        let imageSize = image.size
        let boundingBox = observation.boundingBox
        
        let x = boundingBox.origin.x * imageSize.width
        let y = (1 - boundingBox.origin.y) * imageSize.height
        let width = boundingBox.size.width * imageSize.width
        let height = boundingBox.size.height * imageSize.height
        
        let cropRect = CGRect(x: x, y: y - height, width: width, height: height)
        
        if let cgImage = image.cgImage?.cropping(to: cropRect) {
            return UIImage(cgImage: cgImage)
        }
        
        return nil
    }
    
    func performOCR(on image: UIImage, completion:(_ str:String)->()) {
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let textRecognitionRequest = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text found")
                return
            }

            var detectedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                detectedText += topCandidate.string + "\n"
            }
            print("Detected text: \(detectedText)")
        }

        do {
            try requestHandler.perform([textRecognitionRequest])
        } catch {
            print("Error: \(error)")
        }
    }
    
    
    @objc private func layerPressedd(_ button:UIButton) {
        print(button.layer.name, " tgerfwdq")
        
    }
    
    @objc private func layerPressed(_ sender: UITapGestureRecognizer) {
        print(sender.view?.layer.name, " tgerfwdq")
    }
    
}

private extension DetectText {
    func addShapes(observation:[VNTextObservation], imgView:UIImageView) -> [CAShapeLayer] {

        return observation.map {
            let w = $0.boundingBox.size.width * imgView.bounds.width
            let h = $0.boundingBox.size.height * imgView.bounds.height
            let x = $0.boundingBox.origin.x * imgView.bounds.width
            let y = abs(($0.boundingBox.origin.y * imgView.bounds.height) - imgView.bounds.height) - h
            let layer = CAShapeLayer()
            layer.frame = .init(x: x, y: y, width: w, height: h)
            layer.borderColor = UIColor.red.cgColor
            layer.cornerRadius = 6
            layer.borderWidth = 1
            return layer
        }
    }
    
    func imgString(from image: UIImage, compl:@escaping(_ str:String)->()) {
        guard let cgImage = image.cgImage else { return }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        let request = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                print("No text found")
                return
            }
            
            var recognizedText = ""
            for observation in observations {
                guard let topCandidate = observation.topCandidates(1).first else { continue }
                recognizedText += topCandidate.string + "\n"
            }
            compl(recognizedText)
           // compl(recognizedText)
            print("Recognized text: \(recognizedText)")
            // Use recognizedText here
        }
        
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Error: \(error)")
        }
    }
    
    func cropString(boxes:[VNRectangleObservation], in imgView:UIImageView, result:(String)->()) {
        var results:String = ""
        var charactedImgs:[UIImage] = []
        boxes.forEach { box in
            let boundingBox = VNImageRectForNormalizedRect(box.boundingBox, Int(imgView.frame.width), Int(imgView.frame.height))
            
            if let croppedImage = imgView.image?.cgImage?.cropping(to: boundingBox)
            {
                let ciImage = UIImage(cgImage: croppedImage)
                charactedImgs.append(ciImage)
            }
        }

        charactedImgs.forEach { img in
            self.performOCR(on: img) { str in
                results.append(str)
                if img == charactedImgs.last {
                    result(results)
                }
            }
        }
        
        
    }
}

extension UIView {
    func addConstaits(_ constants:[NSLayoutConstraint.Attribute:CGFloat], superV:UIView) {
        let layout = superV
        constants.forEach { (key, value) in
            let keyNil = key == .height || key == .width
            let item:Any? = keyNil ? nil : layout
            superV.addConstraint(.init(item: self, attribute: key, relatedBy: .equal, toItem: item, attribute: key, multiplier: 1, constant: value))
        }
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func contains(_ touches: Set<UITouch>) -> Bool {
        print(frame, " viewframee")
        print(touches.first?.location(in: self), " locationtouch")
            if let loc = touches.first?.location(in: self),
               loc.inRangeX(frame: frame) {
                
                return true
            } else {
                return false
            }
        }
}

extension CGPoint {
    func inRangeX(frame:CGRect) -> Bool {
        let rangeY = (frame.minY - 45)..<(frame.minY + frame.height + 50)
        let containsY = rangeY.contains(y * 16.6) || rangeY.contains(y * 15.9) || rangeY.contains(y * 17.0)
        print(containsY, " containscontainscontains")
//        let rangeX = (frame.minX - 250).selfMin()..<(frame.minX + frame.width + 500)
//        let containsX = rangeX.contains(x)
//        print(containsX, " containsXcontainsXcontainsXcontainsX")
        return containsY //&& containsX
    }
}

extension CGFloat {
    func selfMin(_ min:CGFloat = 0) -> CGFloat {
        return self <= 0 ? 0 : self
    }
}
