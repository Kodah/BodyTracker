//
//  CustomCameraViewController.swift
//  BodyTrack
//
//  Created by lord on 19/12/2016.
//  Copyright © 2016 Tom Sugarex. All rights reserved.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController {

    @IBOutlet weak var capturedImageView: UIImageView!
    
    @IBOutlet weak var timerButton: UIButton!
    @IBOutlet weak var timerLabel: UILabel!
    
    
    let captureSession = AVCaptureSession()
    let stillImageOutput = AVCaptureStillImageOutput()
    var captureDeviceBack : AVCaptureDevice?
    var captureDeviceFront : AVCaptureDevice?
    var timer = Timer()
    var timerStep = 0.0 {
        didSet {
            switch timerStep {
            case 5:
                timerButton.setTitle("5 seconds", for: .normal)
            case 10:
                timerButton.setTitle("10 Seconds", for: .normal)
                
            default:
                timerButton.setTitle("Off", for: .normal)
            }
        }
    }
    var timerCounter = 0.0 {
        didSet{
            if timerCounter > 0 {
                timerLabel.text = "\(Int(timerCounter))"
                
            } else {
                timerLabel.text = ""
            }
        }
    }
    

    @IBOutlet weak var camView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.setNavigationBarHidden(true, animated: false)
        
        captureSession.sessionPreset = AVCaptureSessionPresetPhoto
        
        let devices: [AnyObject] = AVCaptureDevice.devices() as [AnyObject]
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {

                if(device.position == AVCaptureDevicePosition.back) {
                    captureDeviceBack = device as? AVCaptureDevice
                }
                if(device.position == AVCaptureDevicePosition.front) {
                    captureDeviceFront = device as? AVCaptureDevice
                }
            }
        }
        
        if captureDeviceFront != nil || (captureDeviceBack != nil) {
            beginSession()
        }
    }

    
    func beginSession() {
        
        configureDevice()
        
        do {
            try captureSession.addInput(AVCaptureDeviceInput(device: captureDeviceFront))
        } catch let error {
            print(error.localizedDescription)
        }
        
        if let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) {
            camView.layer.addSublayer(previewLayer)
            previewLayer.frame = camView.layer.frame
        }
        
        
        captureSession.startRunning()
        stillImageOutput.outputSettings = [AVVideoCodecKey:AVVideoCodecJPEG]
        if captureSession.canAddOutput(stillImageOutput) {
            captureSession.addOutput(stillImageOutput)
        }
    }

    func configureDevice() {
        if let device = captureDeviceFront  {
            
            if (device.isFocusModeSupported(.locked)) {
                do {
                    try device.lockForConfiguration()
                    device.focusMode = .locked
                    device.unlockForConfiguration()
                } catch {}
            }
        }
    }
    
    
    @IBAction func takePhotoButtonPressed(_ sender: Any) {
        
        if timerStep > 0 {
            
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
            
        } else {
            captureImage()
        }
    }
    
    func countDown() {
        
        timerCounter += 1
        
        print(timerCounter)
        if timerCounter >= timerStep {
            timerCounter = 0
            timer.invalidate()
            captureImage()
        }
    }
    
    func captureImage() {
        if let videoConnection = stillImageOutput.connection(withMediaType: AVMediaTypeVideo) {
            stillImageOutput.captureStillImageAsynchronously(from: videoConnection) {
                (imageDataSampleBuffer, error) -> Void in
                
                let imageData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer)
                
                if let data = imageData {
                    self.capturedImageView.image = UIImage(data: data)
                    
                }
            }
        }
    }
    
    @IBAction func timerButtonPressed(_ sender: UIButton) {
        
        if (timerStep == 10)
        {
            timerStep = 0
        }
        else {
            timerStep += 5

        }
    }
    

}
