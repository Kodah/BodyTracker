//
//  DatePickerViewController.swift
//  BodyTrack
//
//  Created by Tom Sugarex on 21/06/2015.
//  Copyright (c) 2015 Tom Sugarex. All rights reserved.
//

import UIKit

protocol DatePickerViewControllerDelegate
{
    func dismissDatePicker()
    func datePickerDidChoose(_ date : Date)
}

class DatePickerViewController: UIViewController {

    
    var delegate : DatePickerViewControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareDatePickerToShowWithDate(_ date : Date)
    {
        datePicker.setDate(date, animated: false)
    }

    @IBAction func cancelButtonTapped(_ sender: UIButton)
    {
        if let delegate = delegate
        {
            delegate.dismissDatePicker()
        }
    }

    @IBAction func doneButtonTapped(_ sender: UIButton)
    {
        if let delegate = delegate
        {
            delegate.datePickerDidChoose(datePicker.date)
        }
    }
}
