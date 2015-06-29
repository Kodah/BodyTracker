//
//  EditProgressCollectionViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 25/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class EditProgressCollectionViewController: UIViewController, UITextFieldDelegate {

    
    @IBOutlet var changeNameTextField: UITextField!
    @IBOutlet var colorPickerView: HRColorPickerView!
    
    var progressCollection : ProgressCollection?
    var context : NSManagedObjectContext?
    
    var inputtedName : String?
    
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
            self.changeNameTextField.text = progressCollection.name
            
        }
        
        self.colorPickerView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        self.colorPickerView.addTarget(self, action: "colorDidChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.changeNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = NSString(string: textField.text).stringByReplacingCharactersInRange(range, withString: string)
        
        self.navigationItem.title = textField.text
        self.inputtedName = textField.text
        
        self.navigationItem.rightBarButtonItem?.enabled = count(textField.text) > 0 ? true : false
        
        return false
    }
    
    @IBAction func tapBackground(sender: AnyObject)
    {
        self.changeNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
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
