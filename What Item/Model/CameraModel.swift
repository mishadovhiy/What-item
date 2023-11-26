//
//  CameraModel.swift
//  What Item
//
//  Created by Misha Dovhiy on 25.11.2023.
//  Copyright © 2023 Misha Dovhiy. All rights reserved.
//

import AVFoundation
import UIKit

struct CameraModel {

    var session:AVCaptureSession
    var output:AVCapturePhotoOutput
    var layer:AVCaptureVideoPreviewLayer?

    init(view:UIView) {
        session = .init()
        output = AVCapturePhotoOutput()
        session.sessionPreset = .photo
        let device = AVCaptureDevice.default(for: .video)
        if let device = device,
           let input = try? AVCaptureDeviceInput(device: device),
           session.canAddInput(input)
        {
            session.addInput(input)
            if session.canAddOutput(output) {
                session.addOutput(output)
                layer = AVCaptureVideoPreviewLayer(session: session)
                layer?.videoGravity = .resizeAspectFill
                layer?.frame = view.frame
                view.layer.insertSublayer(layer!, at: 0)
                DispatchQueue(label: "camera", qos: .userInitiated).async { [self] in
                    self.session.startRunning()

                }
                
            }
        }
    }

    func updateFrame(_ newFrame:CGRect) {
        layer?.frame = newFrame
    }
    
}
