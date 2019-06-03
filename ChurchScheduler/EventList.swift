//
//  EventList.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/27/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

class EventList: Codable {
    
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
        let eventDayComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)
        let eventDay = Calendar.current.date(from: eventDayComponents)!
        return events[eventDay] ?? []
    }
    
}
