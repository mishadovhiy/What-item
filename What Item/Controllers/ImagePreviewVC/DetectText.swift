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
    func recognize(img:UIImageView) {
        DispatchQueue(label: "ml", qos: .userInitiated).async {
            let request = VNDetectTextRectanglesRequest { request, error in
                guard let obthervations = request.results as? [VNTextObservation] else { return }
                DispatchQueue.main.async {
                    self.addShapes(observation: obthervations, imgView: img).forEach {
                        let view = UIView(frame: $0.frame)
                        img.layer.addSublayer($0)
                        img.addSubview(view)
                        let gesture = UITapGestureRecognizer(target: nil, action: #selector(self.layerPressed(_:)))
                        view.addGestureRecognizer(gesture)
                       // img.addSubview(view)
                    }
                }
                
//                var detectedText = ""
//                let req2 = request.results as! [VNRecognizedTextObservation]
//                req2.forEach { obj in
//                    detectedText += obj.topCandidates(1).first?.string ?? "?"
//                }
//                print("detectedTextdetectedTextdetectedText ",detectedText, " detectedTextdetectedTextdetectedText")
                
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
    
    
    @objc private func layerPressed(_ sender: UITapGestureRecognizer) {
        print(sender.name)
    }
    
}

private extension DetectText {
    func addShapes(observation:[VNTextObservation], imgView:UIImageView) -> [CAShapeLayer] {
        imgView.image
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
            let topCandidate = $0.characterBoxes?.first
            
            let text = ""//cropString(box: $0.bo, in: imgView)
            print($0, " ythrtgerfw")
            layer.name = text
            return layer
        }
    }
    
    private func cropString(boxes:[VNRectangleObservation], in imgView:UIImageView) -> String? {
        var results:String = ""
        boxes.forEach { box in
            let boundingBox = VNImageRectForNormalizedRect(box.boundingBox, Int(imgView.frame.width), Int(imgView.frame.height))
            
            if let croppedImage = imgView.image?.cgImage?.cropping(to: boundingBox)
            {
//                let ciImage = CIImage(cgImage: croppedImage)
//                let tesseract = G8Tesseract(language: "eng")
//                tesseract?.image = croppedImage
//                tesseract?.recognize()
//                if let recognizedText = tesseract?.recognizedText {
//                    results.append(recognizedText)
//                } else {
//                    //return nil
//                }

            } else {
               // return nil
            }
        }
        
        return results
    }
}
