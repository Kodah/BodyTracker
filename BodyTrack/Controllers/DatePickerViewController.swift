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
    func datePickerDidChoose(date : NSDate)
}

class DatePickerViewController: UIViewController {

    
    var delegate : DatePickerViewControllerDelegate?
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func prepareDatePickerToShowWithDate(date : NSDate)
    {
        self.datePicker.setDate(date, animated: false)
    }

    @IBAction func cancelButtonTapped(sender: UIButton)
    {
        if let delegate = self.delegate
        {
            delegate.dismissDatePicker()
        }
    }

    @IBAction func doneButtonTapped(sender: UIButton)
    {
        if let delegate = self.delegate
        {
            delegate.datePickerDidChoose(self.datePicker.date)
        }
    }
}
