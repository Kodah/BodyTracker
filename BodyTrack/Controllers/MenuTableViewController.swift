//
//  MenuTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {

    enum TableViewSection: Int
    {
        case Main
        case More
        case Count
    }
    
    enum MoreTableViewCell: Int
    {
        case Settings
        case New
        case Count
    }
    
    let CellIdentifier = "MenuCellId"
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {

        return TableViewSection.Count.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch (section)
        {
            case TableViewSection.Main.rawValue:
                return 1;
            case TableViewSection.More.rawValue:
                return MoreTableViewCell.Count.rawValue
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier) as UITableViewCell
        
        switch (indexPath.section)
        {
            case TableViewSection.Main.rawValue:
            
                cell.backgroundColor = UIColor.purpleColor()
                cell.textLabel?.text = "Bicep"
                break
            case TableViewSection.More.rawValue:
            
                switch (indexPath.row)
                {
                case MoreTableViewCell.Settings.rawValue:
                    cell.textLabel?.text = "Settings"
                    break
                case MoreTableViewCell.New.rawValue:
                    cell.textLabel?.text = "New Body Tracker"
                    break
                default:
                    break
                }
        default:
            break
        }
        return cell
    }
    
    
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        var headerTitle:String = ""
        
        switch (section)
        {
        case TableViewSection.More.rawValue:
            headerTitle = "More"
            break
        default:
            break
        }
        return headerTitle
    }
}

    
    
    
    
    
    
    
























