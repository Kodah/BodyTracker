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
    
    
    func getCameraFromHelper() -> UIImagePickerController
    {
        var picker = UIImagePickerController()
        
        picker.delegate = self
        picker.allowsEditing = true
        picker.sourceType = UIImagePickerControllerSourceType.Camera
    
        picker.showsCameraControls = true
        picker.navigationBarHidden = true
    
        return picker
    }
    
    
    
//    - (IBAction)takePhoto:(UIButton *)sender {
//    
//    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//    picker.delegate = self;
//    picker.allowsEditing = YES;
//    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//    
//    picker.showsCameraControls = YES;
//    picker.navigationBarHidden = YES;
//    picker.wantsFullScreenLayout = YES;
//    
//    UIView *overlay = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
//    
//    overlay.backgroundColor = [UIColor blueColor];
//    
//    
//    UIImage *image = [UIImage imageNamed:@"bicep.jpg"];
//    
//    UIImageView *overlayImage = [[UIImageView alloc] initWithImage:image];
//    overlay.frame = overlay.bounds;
//    
//    [overlay addSubview:overlayImage];
//    
//    
//    overlay.alpha = 0.5f;
//    
//    picker.cameraOverlayView = overlay;
//    
//    [self presentViewController:picker animated:YES completion:NULL];
//    
//    }
}
