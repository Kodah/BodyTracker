//
//  MenuTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData

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
    var context: NSManagedObjectContext?
    var progressCollections = [ProgressCollection]()
    var selectedProgressCollection : ProgressCollection?

    var slidingVC = slidingViewController

    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        let fetchRequest = NSFetchRequest(entityName: "ProgressCollection")
        
        self.progressCollections = context!.executeFetchRequest(fetchRequest, error: nil) as! [ProgressCollection]
//
        self.selectedProgressCollection = self.progressCollections.first

        self.clearsSelectionOnViewWillAppear = false

    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int
    {

        return TableViewSection.Count.rawValue
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        let sectionEnum = section
        
        switch (section)
        {
            case TableViewSection.Main.rawValue:
                return self.progressCollections.count;
            case TableViewSection.More.rawValue:
                return MoreTableViewCell.Count.rawValue
            default:
                return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        var cell = tableView.dequeueReusableCellWithIdentifier(CellIdentifier)as! UITableViewCell
        
        switch (indexPath.section)
        {
            case TableViewSection.Main.rawValue:
            
                cell.backgroundColor = UIColor.purpleColor()
                cell.textLabel?.text = self.progressCollections[indexPath.row].name
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
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        switch (indexPath.section)
        {
        case TableViewSection.Main.rawValue:
            println("Load \"\(self.progressCollections[indexPath.row].name)\" progressCollection into top level view controller")
            
            self.selectedProgressCollection = self.progressCollections[indexPath.row]

            var photoSelectionCollectionViewController : PhotoSelectionCollectionViewController = self.storyboard!.instantiateViewControllerWithIdentifier("homeNavigationControllerId") as! PhotoSelectionCollectionViewController
            
            photoSelectionCollectionViewController.progressCollection = self.selectedProgressCollection
            PhotoSelectionCollectionViewController.setBackgrounColour()
            
            self.slidingViewController().resetTopViewAnimated(true)

            break
            
        case TableViewSection.More.rawValue:

            switch (indexPath.row)
            {
            case MoreTableViewCell.New.rawValue:
                println("Create new progressCollection")
                break;
            case MoreTableViewCell.Settings.rawValue:
                println("Display Settings Page")
                break
            default:
                break
            }
            
        default:
            break
        }
        

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

    
    
    
    
    
    
    
























