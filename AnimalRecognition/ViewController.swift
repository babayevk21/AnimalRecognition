//
//  ViewController.swift
//  AnimalRecognition
//
//  Created by Babayev Kamran on 12.03.23.
//

import UIKit
import CoreML
import Vision

class ViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet weak var imageView: UIImageView!
    
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            
            imageView.image = userPickedImage
            
            guard let ciimage = CIImage(image: userPickedImage) else {
                fatalError("Error to convert UIImage to CIImage")
            }
            
            detect(image: ciimage)
        }
        
        imagePicker.dismiss(animated: true)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: PetImageClassifier().model) else {
            fatalError("Loading CoreML Model Error!")
        }
        
        let request = VNCoreMLRequest(model: model) { request, error in
            
            guard let classification = request.results?.first as? VNClassificationObservation else {
                fatalError("Couldn't classify image")
            }
            
            self.navigationItem.title = classification.identifier.capitalized

        }
        
        let hander = VNImageRequestHandler(ciImage: image)
        
        do {
            try hander.perform([request])
        } catch {
            print(error)
        }
    }
    
    
    
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true)
    }
    
}

