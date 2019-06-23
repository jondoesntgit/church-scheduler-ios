//
//  DateExtensions.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/9/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import Foundation

extension Date {
    
    // Dates contain a lot of precision. This is a useful utility function for checking
    // if two dates are on the same day, by "rounding" them to a day.
    func roundedToDay() -> Date {
        return Calendar.current.startOfDay(for: self)
    }
    
    // Pulls the month out of the date.
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
    }
    
    func nextDay() -> Date {
        let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: self, wrappingComponents: false)!
        return Calendar.current.startOfDay(for: nextDay)
    }
    
    // A convenience initializer
    init(year: Int, month: Int, day: Int) {
        let dayComponents = DateComponents(year: year, month: month, day: day)
        self = Calendar.current.date(from: dayComponents)!
    }
}
