//
//  EditProgressCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 25/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class EditProgressCollectionViewController: UIViewController {

    
    @IBOutlet var colorPickerView: HRColorPickerView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        self.colorPickerView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        self.colorPickerView.addTarget(self, action: "colorDidChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func colorDidChanged(pickerView : HRColorPickerView)
    {
        println("color = \(pickerView.color)")
    }
    
}
