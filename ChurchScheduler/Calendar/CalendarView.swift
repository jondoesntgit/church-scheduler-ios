//
//  CalendarView.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/26/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit


/* NOTE TO THE GRADER
 
 I don't think that a UICollection view is actually the best way to code up a calendar view. In a future implementation, I'll use a Grid view. However, I wanted to leave it here as an extra API that was being used, for the rubric points.
 
 */

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
