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
    
    var isActive: Bool = false {
        didSet {
            backgroundColor = isActive ? UIColor.gray : UIColor.clear
        }
    }
    
    private struct Constants {
        static var spacingToDiameterRatio: CGFloat = 0.2
        static var maxNumberOfDotsToShow = 4
    }
    
    var dotWidth: CGFloat {
        get {
            let totalWidth = bounds.width
            let denominator = CGFloat((Constants.spacingToDiameterRatio + 1) * CGFloat(Constants.maxNumberOfDotsToShow) + 1)
            return CGFloat(min(totalWidth/denominator, bounds.height))
        }
    }
    
    var events: [Event] = []
    
    override func didAddSubview(_ view: UIView) {
        view.isUserInteractionEnabled = true
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleTap(by:))))
    }
    
    override func draw(_ rect: CGRect) {
        let numberOfEvents = events.count
        for index in 0..<numberOfEvents {
            let startY = bounds.maxY - dotWidth
            let startX = bounds.midX - dotWidth / 2
                + CGFloat(Double(index) - Double(numberOfEvents - 1) / 2) * (Constants.spacingToDiameterRatio + 1) * dotWidth
            let circleBounds = CGRect(x: startX, y: startY, width: dotWidth, height: dotWidth)
            let circle = UIBezierPath(ovalIn: circleBounds)
            UIColor.blue.setFill()
            circle.fill()
        }
    }
    
    @objc func handleTap(by: UITapGestureRecognizer) {
        delegate?.setActiveDate(date)
    }
}
