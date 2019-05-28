//
//  Event.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/27/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class Event {
    
    var name: String
    var startTime: Date = Date()
    var endTime: Date?
    var day: Date {
        get {
            let components = Calendar.current.dateComponents([.year, .month, .day], from: startTime)
            let truncated = Calendar.current.date(from: components)!
            return truncated
        }
    }
    
    init(name: String) {
        self.name = name
    }
    
    
}
