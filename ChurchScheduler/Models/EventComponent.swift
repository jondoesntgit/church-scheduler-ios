//
//  EventComponent.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/31/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class EventComponent: Codable {
    var leftText: String?
    var rightText: String?
    var centerText: String?
    
    init(withLeftText leftText: String?, withRightText rightText: String?, withCenterText centerText: String?) {
        self.leftText = leftText
        self.rightText = rightText
        self.centerText = centerText
    }
    
}
