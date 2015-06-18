//
//  ImagePickerControllerHelper.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 18/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ImagePickerControllerHelper: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate
{
    @IBOutlet weak var photoSelectionCollectionViewController: PhotoSelectionCollectionViewController!
    
    var image : UIImage?
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!)
    {
    self.photoSelectionCollectionViewController.createNewProgressPoint(image)
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController)
    {
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    func getImagePickerFromHelper() -> UIImagePickerController
    {
        var picker : UIImagePickerController = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary

        return picker
    }
}
