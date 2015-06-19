//
//  ProgressPointDetailTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ProgressPointDetailTableViewController: UITableViewController {

    enum TableViewCell: Int
    {
        case Date
        case Measurement
        case BodyWeight
        case BodyFat
        case Count
    }
    
    var progressPoint: ProgressPoint?
    
    @IBOutlet var imageView: UIImageView!
    
    let TableViewCellIdentifier = "Cell"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        if let progressPoint = self.progressPoint
        {
            if let imageView = self.imageView
            {
                if let image = self.progressPoint?.getImage()
                {
                    imageView.image = image
                }
            }
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {

        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableViewCell.Count.rawValue
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier(TableViewCellIdentifier, forIndexPath: indexPath) as! UITableViewCell
        
        switch indexPath.row
        {
        case TableViewCell.Date.rawValue:
            cell.textLabel?.text = "Date"
            if let date = self.progressPoint?.date
            {
                var dateformatter = NSDateFormatter()
                dateformatter.dateFromString("dd-MM-yyyy")
                cell.detailTextLabel?.text = dateformatter.stringFromDate(date)
            }
            
            break
            
        case TableViewCell.Measurement.rawValue:
            cell.textLabel?.text = "Measurement (cm)"
            if let measurement = self.progressPoint?.measurement
            {
                cell.detailTextLabel?.text = "\(measurement) cm"
            }
            break
        case TableViewCell.BodyWeight.rawValue:
            cell.textLabel?.text = "Body Weight (kg)"
            if let weight = self.progressPoint?.weight
            {
                cell.detailTextLabel?.text = "\(weight) kg"
            }
            break
        case TableViewCell.BodyFat.rawValue:
            cell.textLabel?.text = "Body Fat (%)"
            if let bodyFat = self.progressPoint?.bodyFat
            {
                cell.detailTextLabel?.text = "\(bodyFat) %"
            }
            break
        default:
            break
        }
        return cell
    }
}
