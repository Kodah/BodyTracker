//
//  ImagePickerControllerHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ImagePickerControllerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    @IBOutlet weak var photoSelectionCollectionViewController: PhotoSelectionCollectionViewController!

    var image: UIImage?

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            photoSelectionCollectionViewController.createNewProgressPoint(image)
            picker.dismiss(animated: true, completion: nil)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }

    func getImagePickerFromHelper() -> UIImagePickerController {
        let picker: UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = false

        picker.sourceType = UIImagePickerControllerSourceType.photoLibrary

        return picker
    }

    func getCameraFromHelper() -> UIImagePickerController {
        let picker = UIImagePickerController()

        picker.delegate = self
        picker.allowsEditing = false
        picker.sourceType = UIImagePickerControllerSourceType.camera

        picker.showsCameraControls = false
        picker.isNavigationBarHidden = true

//        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let controller = storyboard.instantiateViewController(withIdentifier: "imagePickerOverlayViewController") 

        let overlayView = UIView(frame: CGRect(x:0,
                                               y: 0,
                                               width: picker.view.frame.size.width,
                                               height: picker.view.frame.size.height-44))

        overlayView.backgroundColor = UIColor.green

        picker.cameraOverlayView = overlayView

        return picker
    }
}
