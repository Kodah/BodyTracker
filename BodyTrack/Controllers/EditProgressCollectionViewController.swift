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
    @IBOutlet var reminderLabel: UILabel!
    @IBOutlet var stepper: UIStepper!
    
    var progressCollection : ProgressCollection?
    var context : NSManagedObjectContext?
    
    var inputtedName : String?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        
        if let progressCollection = progressCollection
        {
            colorPickerView.color = UIColor(rgba: progressCollection.colour)
            navigationItem.title = progressCollection.name
            
            navigationController?.navigationBar.translucent = false
            navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.whiteColor()]
            navigationController?.navigationBar.tintColor = UIColor.whiteColor()
            changeNameTextField.text = progressCollection.name
            
            if progressCollection.interval == 0
            {
                reminderLabel.text = "Reminders off"
            }
            else
            {
                reminderLabel.text = "Reminder every \(progressCollection.interval) weeks"
            }
            stepper.value = progressCollection.interval.doubleValue
        }
        
        colorPickerView.tintAdjustmentMode = UIViewTintAdjustmentMode.Normal
        colorPickerView.addTarget(self, action: "colorDidChanged:", forControlEvents: UIControlEvents.ValueChanged)
        changeNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func stepperDidChange(sender: UIStepper)
    {
        if let progressCollection = progressCollection
        {
            progressCollection.interval = stepper.value
            
            if stepper.value == 0
            {
                reminderLabel.text = "Reminders off"
            }
            else
            {
                reminderLabel.text = "Reminder every \(progressCollection.interval) weeks"
            }
        }
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        textField.text = NSString(string: textField.text).stringByReplacingCharactersInRange(range, withString: string)
        
        navigationItem.title = textField.text
        inputtedName = textField.text
        
        navigationItem.rightBarButtonItem?.enabled = count(textField.text) > 0 ? true : false
        
        return false
    }
    
    @IBAction func tapBackground(sender: AnyObject)
    {
        changeNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func colorDidChanged(pickerView : HRColorPickerView)
    {
        navigationController?.navigationBar.barTintColor = pickerView.color
    }
    
    @IBAction func cancelButtonTapped(sender: AnyObject)
    {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(sender: UIBarButtonItem)
    {
        if let progressCollection = progressCollection, context = context
        {
            progressCollection.name = navigationItem.title
            progressCollection.colour = UIColor.hexValuesFromUIColor(colorPickerView.color)
            
            NotificationFactory().scheduleNotificationForProgressCollection(progressCollection)

            context.save(nil)
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
}
