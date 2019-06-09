//
//  EventDatePickerTableViewCell.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/3/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

enum StartOrStop{
    case start
    case stop
}

class EventDatePickerTableViewCell: UITableViewCell, UITextFieldDelegate {
    
    private struct Storyboard {
        static let startLabel = "Start time"
        static let stopLabel = "Stop time"
        static let datePickerDoneText = "Done"
    }

    var event: Event!
    @IBOutlet weak var startStopTimeLabel: UILabel!
    @IBOutlet weak var timeTextField: UITextField!
    
    var datePicker = UIDatePicker()
    var startOrStop: StartOrStop! {
        didSet {
            if event != nil {
                switch startOrStop! {
                case .start:
                    startStopTimeLabel.text = Storyboard.startLabel
                    setText(withDate: event.startTime)
                    datePicker.date = event.startTime
                case .stop:
                    startStopTimeLabel.text = Storyboard.stopLabel
                    setText(withDate: event.endTime)
                    datePicker.date = event.endTime ?? Date()
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        timeTextField.delegate = self
        timeTextField.inputView = datePicker
        timeTextField.tintColor = .clear
        datePicker.backgroundColor = .white
        datePicker.addTarget(self, action: #selector(EventDatePickerTableViewCell.dateChanged(datePicker:)), for: .valueChanged)
        
        // Datepicker toolbar setup
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        let space = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        let doneButton = UIBarButtonItem(title: Storyboard.datePickerDoneText, style: UIBarButtonItem.Style.done, target: self, action: #selector(EventDatePickerTableViewCell.doneDatePickerPressed))
        
        // Add the space so that doneButton is right-aligned
        toolBar.setItems([space, doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        toolBar.sizeToFit()
        
        timeTextField.inputAccessoryView = toolBar
    }
    
    @objc func doneDatePickerPressed() {
        timeTextField.isUserInteractionEnabled = false
        timeTextField.resignFirstResponder()
    }
    
    func setText(withDate: Date?) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd hh:mm a"
        if let date = withDate {
            timeTextField.text = dateFormatter.string(from: date)
        }
        switch startOrStop! {
        case .start:
            if let startDate = withDate {
                event.startTime = startDate
            }
        case .stop:
            event.endTime = withDate
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker) {
        setText(withDate: datePicker.date)
    }
}
