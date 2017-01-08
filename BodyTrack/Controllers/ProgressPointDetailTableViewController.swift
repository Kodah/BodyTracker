//
//  ProgressPointDetailTableViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarev on 19/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

class ProgressPointDetailTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,
UIAlertViewDelegate, DatePickerViewControllerDelegate {

    enum TableViewCell: Int {
        case date
        case measurement
        case bodyWeight
        case bodyFat
        case delete
        case count
    }

    var progressPoint: ProgressPoint?
    var selectedStat: TableViewCell.RawValue?
    var context: NSManagedObjectContext?
    var datePickerViewController: DatePickerViewController?

    @IBOutlet weak var containerConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var imageView: UIImageView!

    final let tableViewCellIdentifier = "Cell"
    final let tableViewCellIdentifierDelete = "DeleteCellId"
    final let datePickerContainerIdentifier = "DatePickerContainerId"

    override func viewDidLoad() {
        super.viewDidLoad()

        if let gestures = navigationController!.navigationBar.gestureRecognizers {
            for gesture  in gestures {
                if gesture.isKind(of: UITapGestureRecognizer.self) {
                    if let gesture = gesture as? UITapGestureRecognizer {
                        gesture.isEnabled = false
                    }
                }
            }
        }

        if let progressPoint = progressPoint, let imageView = imageView, let image = progressPoint.getImage() {
            imageView.image = image
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let gestures = navigationController!.navigationBar.gestureRecognizers {
            for gesture  in gestures {
                if gesture.isKind(of: UITapGestureRecognizer.self) {
                    if let gesture = gesture as? UITapGestureRecognizer {
                        gesture.isEnabled = true
                    }
                }
            }
        }
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return TableViewCell.count.rawValue
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == TableViewCell.delete.rawValue {
            let deleteCell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifierDelete,
                                                           for: indexPath)

            return deleteCell
        }

        let cell = tableView.dequeueReusableCell(withIdentifier: tableViewCellIdentifier, for: indexPath)

        switch indexPath.row {
        case TableViewCell.date.rawValue:
            cell.textLabel?.text = "Date"
            if let date = progressPoint?.date {
                let dateformatter = DateFormatter()
                dateformatter.timeStyle = DateFormatter.Style.none
                dateformatter.dateStyle = DateFormatter.Style.short
                dateformatter.dateFormat = "dd MMM yyyy"
                cell.detailTextLabel?.text = dateformatter.string(from: date)
            }

        case TableViewCell.measurement.rawValue:
            cell.textLabel?.text = "Measurement (cm)"
            if let measurement = progressPoint?.measurement {
                cell.detailTextLabel?.text = "\(measurement) cm"
            }

        case TableViewCell.bodyWeight.rawValue:
            cell.textLabel?.text = "Body Weight (kg)"
            if let weight = progressPoint?.weight {
                cell.detailTextLabel?.text = "\(weight) kg"
            }
        case TableViewCell.bodyFat.rawValue:
            cell.textLabel?.text = "Body Fat (%)"
            if let bodyFat = progressPoint?.bodyFat {
                cell.detailTextLabel?.text = "\(bodyFat) %"
            }
        default:
            break
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if indexPath.row == TableViewCell.delete.rawValue {
            // TODO delete progress point

            return
        }

        let alertView = UIAlertView(title: "",
                                    message: "",
                                    delegate: self,
                                    cancelButtonTitle: "Cancel",
                                    otherButtonTitles: "Save")
        alertView.alertViewStyle = UIAlertViewStyle.plainTextInput
        alertView.textField(at: 0)?.keyboardType = UIKeyboardType.decimalPad

        switch indexPath.row {
        case TableViewCell.date.rawValue:

            if let datePickerVC = datePickerViewController, let progressPoint = progressPoint {
                if progressPoint.date != nil {
                    datePickerVC.datePicker.date = progressPoint.date
                } else {
                    datePickerVC.datePicker.date = Date()
                }
            }
            view.layoutIfNeeded()
            containerConstraint.constant = 208
            UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions(), animations: {
                    self.view.layoutIfNeeded()

                }, completion: nil)

        return

        case TableViewCell.measurement.rawValue:

            alertView.title = "Edit measurement"
            alertView.message = "Enter measurement"
            selectedStat = TableViewCell.measurement.rawValue
            break

        case TableViewCell.bodyWeight.rawValue:
            alertView.title = "Edit Body Weight"
            alertView.message = "Enter Body Weight"
            selectedStat = TableViewCell.bodyWeight.rawValue
            break

        case TableViewCell.bodyFat.rawValue:
            alertView.title = "Edit Body Fat"
            alertView.message = "Enter Body Fat"
            selectedStat = TableViewCell.bodyFat.rawValue
            break

        default:
            break

        }

        alertView.show()

    }

    func alertView(_ alertView: UIAlertView, clickedButtonAt buttonIndex: Int) {

        if buttonIndex == 1 {
            if let  text = alertView.textField(at: 0)?.text {
                switch selectedStat! {
                case TableViewCell.measurement.rawValue:

                    progressPoint?.measurement = Int(text) as NSNumber?
                    break

                case TableViewCell.bodyWeight.rawValue:
                    progressPoint?.weight = Int(text) as NSNumber?
                    break
                case TableViewCell.bodyFat.rawValue:
                    progressPoint?.bodyFat = Int(text) as NSNumber?
                    break
                default:
                    break
                }

                do {try context?.save() } catch {}
                tableView.reloadData()
            }

        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier {
            switch identifier {
            case datePickerContainerIdentifier:
                if let datePickerViewController = segue.destination as? DatePickerViewController {
                    datePickerViewController.delegate = self
                    self.datePickerViewController = datePickerViewController
                }

                break
            default:
                break
            }
        }
    }

    // Date picker view controller delegate

    func dismissDatePicker() {
        view.layoutIfNeeded()
        containerConstraint.constant = 0
        UIView.animate(withDuration: 0.75, delay: 0, options: UIViewAnimationOptions(), animations: {
                self.view.layoutIfNeeded()

            }, completion: nil)
    }

    func datePickerDidChoose(_ date: Date) {
        progressPoint?.date = date
        do { try context?.save() } catch {}
        tableView.reloadRows(at: [IndexPath(row: 0, section: 0)], with: UITableViewRowAnimation.automatic)
        dismissDatePicker()
    }
}
