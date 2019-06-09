//
//  CalendarView.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/26/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class CalendarView: UICollectionView {
    
    var activeCell : CalendarDayView?
    
    func setActiveCellByDate(_ date: Date) {
        print(date)
        activeCell?.isActive = false
        for cell in visibleCells {
            if let calendarCell = cell as? CalendarDayView {
                if calendarCell.date == date {
                    activeCell = calendarCell
                    activeCell!.isActive = true
                    return
                }
            }
        }
    }
}
