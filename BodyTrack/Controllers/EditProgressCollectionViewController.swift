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
            
            navigationController?.navigationBar.isTranslucent = false
            navigationController?.navigationBar.barTintColor = UIColor(rgba: progressCollection.colour)
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor.white]
            navigationController?.navigationBar.tintColor = UIColor.white
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
        
        colorPickerView.tintAdjustmentMode = UIViewTintAdjustmentMode.normal
        colorPickerView.addTarget(self, action: "colorDidChanged:", for: UIControlEvents.valueChanged)
        changeNameTextField.delegate = self
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func stepperDidChange(_ sender: UIStepper)
    {
        if let progressCollection = progressCollection
        {
            progressCollection.interval = stepper.value as NSNumber!
            
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
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        textField.text = NSString(string: textField.text!).replacingCharacters(in: range, with: string)
        
        navigationItem.title = textField.text
        inputtedName = textField.text
        
        navigationItem.rightBarButtonItem?.isEnabled = (textField.text?.characters.count)! > 0 ? true : false
        
        return false
    }
    
    @IBAction func tapBackground(_ sender: AnyObject)
    {
        changeNameTextField.resignFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func colorDidChanged(_ pickerView : HRColorPickerView)
    {
        navigationController?.navigationBar.barTintColor = pickerView.color
    }
    
    @IBAction func cancelButtonTapped(_ sender: AnyObject)
    {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem)
    {
        if let progressCollection = progressCollection, let context = context
        {
            progressCollection.name = navigationItem.title
            progressCollection.colour = UIColor.hexValuesFromUIColor(colorPickerView.color)
            
            NotificationFactory().scheduleNotificationForProgressCollection(progressCollection)

            do {
                try context.save()
            } catch  {}
            
            dismiss(animated: true, completion: nil)
        }
    }
    
}
