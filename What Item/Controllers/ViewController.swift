//
//  ViewController.swift
//  What Item
//
//  Created by Misha Dovhiy on 12.02.2020.
//  Copyright © 2020 Misha Dovhiy. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController {

    @IBOutlet weak var itemNametextField: UITextField!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
        itemNametextField.delegate = self
        itemNametextField.becomeFirstResponder()
    }

    override func viewWillAppear(_ animated: Bool) {
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }

    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: Inceptionv3().model) else { fatalError() }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else { fatalError() }

            if let firstResults = results.first {
                V.userWord = self.itemNametextField.text!
                V.itemOnImage = firstResults.identifier.capitalized
                
                if firstResults.identifier.capitalized.contains(V.userWord.capitalized) {
                    V.ifCorrect = true
                } else { V.ifCorrect = false }
                self.performSegue(withIdentifier: K.resultsSegue, sender: self)
            }}
        
        let hendler = VNImageRequestHandler(ciImage: image)
        do { try! hendler.perform([request]) }
    }
    
    func goPressed() {
        
        if itemNametextField.text != "" {
            present(imagePicker, animated: true, completion: nil)
        }
    }

}


//MARK: - imagepicker

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            guard let ciimage = CIImage(image: userPickedImage) else { fatalError() }
            detect(image: ciimage)
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - textField

extension ViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        goPressed()
        return true
    }

}

//MARK: - statusBar
extension UINavigationController {
   open override var preferredStatusBarStyle: UIStatusBarStyle {
      return topViewController?.preferredStatusBarStyle ?? .default
   }
}
