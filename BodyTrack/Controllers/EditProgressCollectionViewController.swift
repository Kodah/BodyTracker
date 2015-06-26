//
//  EditProgressCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 25/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class EditProgressCollectionViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var colorPickerView: HRColorPickerView!
    
    var progressCollection : ProgressCollection?
    var context : NSManagedObjectContext?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        if let progressCollection = self.progressCollection
        {
            self.colorPickerView.color = UIColor(rgba: progressCollection.colour)
            self.navigationItem.title = progressCollection.name
            
            self.navigationController?.navigationBar.translucent = false
            self.navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            
        }
        
        self.colorPickerView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        self.colorPickerView.addTarget(self, action: "colorDidChanged:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = NSString(string: textField.text).stringByReplacingCharactersInRange(range, withString: string)
        
        self.navigationItem.title = textField.text
        
        return false
    }
    
    
    func colorDidChanged(pickerView : HRColorPickerView)
    {
        self.navigationController?.navigationBar.barTintColor = pickerView.color
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem)
    {
        if let progressCollection = self.progressCollection
        {
            progressCollection.name = self.navigationItem.title
            progressCollection.colour = UIColor.hexValuesFromUIColor(self.colorPickerView.color)
            
            if let context = self.context
            {
                context.save(nil)
            }
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
