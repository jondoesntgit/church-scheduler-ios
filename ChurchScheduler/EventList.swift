//
//  EventList.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/27/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class EventList {
    
    var events: [Date: [Event]] = [:]
    
    func add(_ event: Event) {
        let eventDay = event.day
        if events[eventDay] != nil {
            events[eventDay]!.append(event)
        } else {
            events[eventDay] = [event]
        }
    }
    
    func getEventsSameDayAs(_ date: Date) -> [Event] {
        let eventDay = date
        return events[eventDay] ?? []
    }
    
}
