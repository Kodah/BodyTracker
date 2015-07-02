//
//  ProgressPointDetailTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ProgressPointDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, DatePickerViewControllerDelegate {

    enum TableViewCell: Int
    {
        case Date
        case Measurement
        case BodyWeight
        case BodyFat
        case Count
    }
    
    var progressPoint: ProgressPoint?
    var selectedStat : TableViewCell.RawValue?
    var context : NSManagedObjectContext?
    var datePickerViewController : DatePickerViewController?
    
    @IBOutlet weak var containerConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!
    
    let TableViewCellIdentifier = "Cell"
    let DatePickerContainerIdentifier = "DatePickerContainerId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let gestures = navigationController!.navigationBar.gestureRecognizers
        {
            for gesture  in gestures
            {
                if gesture.isKindOfClass(UITapGestureRecognizer)
                {
                    if let gesture = gesture as? UITapGestureRecognizer
                    {
                        gesture.enabled = false
                    }
                }
            }
        }
        
        
        if let progressPoint = progressPoint, imageView = imageView, image = progressPoint.getImage()
        {
            imageView.image = image
        }
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        if let gestures = navigationController!.navigationBar.gestureRecognizers
        {
            for gesture  in gestures
            {
                if gesture.isKindOfClass(UITapGestureRecognizer)
                {
                    if let gesture = gesture as? UITapGestureRecognizer
                    {
                        gesture.enabled = true
                    }
                }
            }
        }
    }
    

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableViewCell.Count.rawValue
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.row
        {
        case TableViewCell.Date.rawValue:
            cell.textLabel?.text = "Date"
            if let date = progressPoint?.date
            {
                var dateformatter = NSDateFormatter()
                dateformatter.timeStyle = NSDateFormatterStyle.NoStyle
                dateformatter.dateStyle = NSDateFormatterStyle.ShortStyle
                dateformatter.dateFormat = "dd MMM yyyy"
                cell.detailTextLabel?.text = dateformatter.stringFromDate(date)
            }
            
            break
            
        case TableViewCell.Measurement.rawValue:
            cell.textLabel?.text = "Measurement (cm)"
            if let measurement = progressPoint?.measurement
            {
                cell.detailTextLabel?.text = "\(measurement) cm"
            }
            break
        case TableViewCell.BodyWeight.rawValue:
            cell.textLabel?.text = "Body Weight (kg)"
            if let weight = progressPoint?.weight
            {
                cell.detailTextLabel?.text = "\(weight) kg"
            }
            break
        case TableViewCell.BodyFat.rawValue:
            cell.textLabel?.text = "Body Fat (%)"
            if let bodyFat = progressPoint?.bodyFat
            {
                cell.detailTextLabel?.text = "\(bodyFat) %"
            }
            break
        default:
            break
        }
        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        var alertView = UIAlertView(title: "", message: "", delegate: self, cancelButtonTitle: "Cancel", otherButtonTitles: "Save")
        alertView.alertViewStyle = UIAlertViewStyle.PlainTextInput
        alertView.textFieldAtIndex(0)?.keyboardType = UIKeyboardType.DecimalPad
        
        switch indexPath.row
        {
        case TableViewCell.Date.rawValue:
            
            if let datePickerVC = datePickerViewController, progressPoint = progressPoint
            {
                if (progressPoint.date != nil)
                {
                    datePickerVC.datePicker.date = progressPoint.date
                }
                else
                {
                    datePickerVC.datePicker.date = NSDate()
                }
            }
            view.layoutIfNeeded()
            containerConstraint.constant = 208
            UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
                {
                    self.view.layoutIfNeeded()
                    
           
                }, completion: nil)
            
        return
            
        case TableViewCell.Measurement.rawValue:
            
            alertView.title = "Edit measurement"
            alertView.message = "Enter measurement"
            selectedStat = TableViewCell.Measurement.rawValue
            break
            
        case TableViewCell.BodyWeight.rawValue:
            alertView.title = "Edit Body Weight"
            alertView.message = "Enter Body Weight"
            selectedStat = TableViewCell.BodyWeight.rawValue
            break
            
        case TableViewCell.BodyFat.rawValue:
            alertView.title = "Edit Body Fat"
            alertView.message = "Enter Body Fat"
            selectedStat = TableViewCell.BodyFat.rawValue
            break
            
        default:
            break
        
        }
        
        alertView.show()
        
    }
    
    func alertView(alertView: UIAlertView, clickedButtonAtIndex buttonIndex: Int)
    {
        
        if buttonIndex == 1
        {
            var text = alertView.textFieldAtIndex(0)?.text
            switch selectedStat!
            {
            case TableViewCell.Measurement.rawValue:
                
                progressPoint?.measurement = text?.toInt()
                break
                
            case TableViewCell.BodyWeight.rawValue:
                progressPoint?.weight = text?.toInt()
                break
            case TableViewCell.BodyFat.rawValue:
                progressPoint?.bodyFat = text?.toInt()
                break
            default:
                break
            }
            context?.save(nil)
            tableView.reloadData()
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if let identifier = segue.identifier
        {
            switch identifier
            {
            case DatePickerContainerIdentifier:
                var datePickerViewController = segue.destinationViewController as! DatePickerViewController
                datePickerViewController.delegate = self
                self.datePickerViewController = datePickerViewController
                break
            default:
                break
            }
        }
        
    }
    
    // Date picker view controller delegate
    
    func dismissDatePicker()
    {
        view.layoutIfNeeded()
        containerConstraint.constant = 0
        UIView.animateWithDuration(0.75, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations:
            {
                self.view.layoutIfNeeded()
                
                
            }, completion: nil)
    }
    
    func datePickerDidChoose(date: NSDate)
    {
        progressPoint?.date = date
        context?.save(nil)
        tableView.reloadRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
        dismissDatePicker()
    }
}
