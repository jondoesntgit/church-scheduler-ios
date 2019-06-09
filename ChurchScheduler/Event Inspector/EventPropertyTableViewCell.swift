//
//  EventPropertyTableViewCell.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/28/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class EventPropertyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var leftLabel: UILabel!
    @IBOutlet weak var rightLabel: UILabel!
    @IBOutlet weak var centerLabel: UILabel!
    
    
    var propertyName: String!
    var propertyValue: Any!
    var eventComponent: EventComponent! {
        didSet {
            leftLabel.text = eventComponent.leftText
            rightLabel.text = eventComponent.rightText
            centerLabel.text = eventComponent.centerText
        }
    }
}
