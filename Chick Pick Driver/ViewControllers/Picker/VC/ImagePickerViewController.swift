//
//  ImagePickerViewController.swift
//  Peppea-Driver
//
//  Created by EWW-iMac Old on 26/06/19.
//  Copyright © 2019 Excellent WebWorld. All rights reserved.
//

import UIKit
import SkyFloatingLabelTextField
class ImagePickerViewController: UIViewController {
    
    @IBOutlet weak var txtDate : SkyFloatingLabelTextField!
    @IBOutlet weak var containerView : UIView!
     @IBOutlet weak var btnGallery : UIButton!
     @IBOutlet weak var btnCamera : UIButton!
  
    var onDismiss : (() -> ())?
    var imageFormat = ""
    var imageName = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
   
    var pickedImage = UIImage()
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch: UITouch? = touches.first
        if touch?.view == view {
            self.dismiss(animated: true)
        }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        containerView.roundCorners([.topLeft,.topRight], radius: 16)
        
    }
    
    @IBAction func pickFromCamera(_ sender: UIButton){
        pickingImageFromGallery(fromCamera: true)
    }
    @IBAction func pickFromGallery(_ sender: UIButton){
        pickingImageFromGallery(fromCamera: false)
    }
    func pickingImageFromGallery(fromCamera: Bool)
    {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        if fromCamera {
            if !UIImagePickerController.isSourceTypeAvailable(.camera){
                AlertMessage.showMessageForError("Your device does not have camera")
                return
            }
        }
        
        picker.sourceType = fromCamera ? .camera : .photoLibrary
        
        present(picker, animated: true, completion: nil)
    }
        
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        UIView.animate(withDuration: 0.3) {
            self.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        view.backgroundColor = .clear
    }


}
extension ImagePickerViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
       
        if let pickedImage = info[.editedImage] as? UIImage {
            self.pickedImage = pickedImage
        } else if let pickedImage = info[.originalImage] as? UIImage {
            self.pickedImage = pickedImage
        }
        
        if onDismiss != nil { onDismiss!() }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
