//
//  MenuTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 14/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit
import CoreData
import ECSlidingViewController

protocol MenuTableViewControllerDelegate: class {
    func newProgressCollectionButtonTapped()
    func setProgressCollection(progressCollection: ProgressCollection)
    // Change this to a didSet delegate thing
//    var progressCollection: ProgressCollection?
}

class MenuTableViewController: UITableViewController {

    enum TableViewSection: Int {
        case main
        case more
        case count
    }

    enum MoreTableViewCell: Int {
        case settings
        case new
        case count
    }

    weak var delegate: MenuTableViewControllerDelegate! = nil
    let cellIdentifier = "MenuCellId"
    var context: NSManagedObjectContext?
    var progressCollections = [ProgressCollection]()
    var selectedProgressCollection: ProgressCollection?

    var slidingVC = slidingViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadProgressCollections()

    }

    func loadProgressCollections() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressCollection")

        do {
            progressCollections = try (context!.fetch(fetchRequest) as? [ProgressCollection])!
        } catch {}

        selectedProgressCollection = progressCollections.first

        clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProgressCollection")
        do {
        progressCollections = try (context!.fetch(fetchRequest) as? [ProgressCollection])!
        } catch {}
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {

        return TableViewSection.count.rawValue
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
            case TableViewSection.main.rawValue:
                return progressCollections.count
            case TableViewSection.more.rawValue:
                return MoreTableViewCell.count.rawValue
            default:
                return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)!

        switch indexPath.section {
            case TableViewSection.main.rawValue:

                cell.backgroundColor = UIColor(rgba: progressCollections[indexPath.row].colour!)
                cell.textLabel?.text = progressCollections[indexPath.row].name
                break
            case TableViewSection.more.rawValue:

                cell.backgroundColor = UIColor.clear
                switch indexPath.row {
                case MoreTableViewCell.settings.rawValue:
                    cell.textLabel?.text = "Settings"
                    break
                case MoreTableViewCell.new.rawValue:
                    cell.textLabel?.text = "New Body Tracker .."
                    break
                default:
                    break
                }
        default:
            break
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case TableViewSection.main.rawValue:
            print(
                "Load \"\(progressCollections[indexPath.row].name)\" progressCollection into top level view controller"
            )

            slidingViewController().resetTopView(animated: true)
            selectedProgressCollection = progressCollections[indexPath.row]
            delegate.setProgressCollection(progressCollection: selectedProgressCollection!)

            break

        case TableViewSection.more.rawValue:

            switch indexPath.row {
            case MoreTableViewCell.new.rawValue:
                print("Create new progressCollection")
                delegate.newProgressCollectionButtonTapped()

                break
            case MoreTableViewCell.settings.rawValue:
                print("Display Settings Page")
                break
            default:
                break
            }

        default:
            break
        }

    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        var headerTitle: String = ""

        switch section {
        case TableViewSection.more.rawValue:
            headerTitle = "More"
            break
        default:
            break
        }
        return headerTitle
    }

    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.section == TableViewSection.main.rawValue &&
            tableView.numberOfRows(inSection: TableViewSection.main.rawValue) > 1 {
            return true
        }
        return false
    }

    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            let alertVC = UIAlertController(title: "Are you sure?",
                                            message: "Cannot undo delete",
                                            preferredStyle: UIAlertControllerStyle.alert)
            let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil)
            let okAction = UIAlertAction(title: "Delete", style: UIAlertActionStyle.destructive, handler: {(_) in
                let progressCollectionToDelete = self.progressCollections[indexPath.row]
                self.context?.delete(progressCollectionToDelete)

                do { try self.context?.save() } catch {}

                self.loadProgressCollections()
                tableView.reloadData()
                self.delegate.setProgressCollection(progressCollection: self.selectedProgressCollection!)
            })

            alertVC.addAction(cancelAction)
            alertVC.addAction(okAction)

            present(alertVC, animated: true, completion: nil)

            // TODO: remove any notification for this progress collection
            // TODO: delete locally stored images
        }
    }
}
