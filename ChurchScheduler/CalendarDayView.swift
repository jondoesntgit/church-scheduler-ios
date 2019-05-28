//
//  CalendarDayView.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/26/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class CalendarDayView: UICollectionViewCell {
    @IBOutlet weak private var dateLabel: UILabel!
    
    var delegate: CalendarViewController?
    
    var date: Date! {
        didSet {
            dateLabel.text = "\(Calendar.current.component(.day, from: date))"
        }
    }
    
    override func didAddSubview(_ view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(by:))))
    }
    
    @objc func handleTap(by: UITapGestureRecognizer) {
        delegate?.setActiveDate(date)
    }
}
