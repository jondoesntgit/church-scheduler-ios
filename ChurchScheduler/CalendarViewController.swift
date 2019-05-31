//
//  CalendarViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/24/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {


    override func viewDidLoad() {
        super.viewDidLoad()
        
        let event1 = Event(name: "Vespers")
        let event2 = Event(name: "Sabbath School")
        let event3 = Event(name: "Church")
        let event4 = Event(name: "Show the TA")
        
        event1.startTime = Date(year: 2019, month: 5, day: 31)
        event2.startTime = Date(year: 2019, month: 6, day: 1)
        event3.startTime = Date(year: 2019, month: 6, day: 1)
        
        eventList.add(event1)
        eventList.add(event2)
        eventList.add(event3)
        eventList.add(event4)
        
        setActiveDate(Date())
        
        // Get current month
        let nowComponents = Calendar.current.dateComponents([.year, .month, .day], from: Date())
        var firstDayOfCurrentMonth = nowComponents
        firstDayOfCurrentMonth.day = 1
        let firstDateOfCurrentMonth = Calendar.current.date(from: firstDayOfCurrentMonth)!
        let firstDateOfCurrentMonthWeekday = Calendar.current.component(.weekday, from: firstDateOfCurrentMonth)
        let numberOfDaysToShowInPreviousMonth = firstDateOfCurrentMonthWeekday - 1
        let firstDateOfCalendar = firstDateOfCurrentMonth.addingTimeInterval(Double(-86400 * numberOfDaysToShowInPreviousMonth))
        var workingDate = firstDateOfCalendar
        
        let numberOfDaysToDisplay = 6 * 7 // 42
        for _ in 1...numberOfDaysToDisplay {
            // TODO: Cleanup if this turns out not to be necessary
            //let dateForView = Calendar.current.component(.day, from: workingDate)
            //dates.append(dateForView)
            dates.append(workingDate)
            workingDate.addTimeInterval(86400)
        }
        
    }
    
    // Mark: - Model
    
    var eventList = EventList()
    var thisDaysEvents = [Event]()
    var dates = [Date]()
    var activeDate = Date().roundedToDay()
    
    
    // Mark: - Collection View
    @IBOutlet weak var calendarView: CalendarView! {
        didSet {
            calendarView.delegate = self
            calendarView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day View Cell", for: indexPath)
        if let calendarDayView = cell as? CalendarDayView {
            let index = indexPath.item
            calendarDayView.delegate = self
            let date = dates[index].roundedToDay()
            calendarDayView.date = date
            calendarDayView.numberOfEvents = eventList.getEventsSameDayAs(date).count
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // Adapted from https://stackoverflow.com/a/54248862
        let numberOfCellsInRow = 7
        let numberOfRows = 6
        let flowLayout = collectionViewLayout as! UICollectionViewFlowLayout
        
        let totalWidth = flowLayout.sectionInset.left
            + flowLayout.sectionInset.right
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfCellsInRow - 1))
        
        let totalHeight = flowLayout.sectionInset.top
            + flowLayout.sectionInset.bottom
            + (flowLayout.minimumInteritemSpacing * CGFloat(numberOfRows - 1))
        
        let width = Int((collectionView.bounds.width - totalWidth) / CGFloat(numberOfCellsInRow))
        let height = Int((collectionView.bounds.height - totalHeight) / CGFloat(numberOfRows))
        
        return CGSize(width: width, height: height)
    }
    
    func setActiveDate(_ date: Date) {
        activeDate = date.roundedToDay()
        thisDaysEvents = eventList.getEventsSameDayAs(date)
        eventTableView.reloadData()
        calendarView.setActiveCellByDate(date)
    }
    
    // MARK: - TableView
    
    
    @IBOutlet weak var eventTableView: UITableView! {
        didSet {
            eventTableView.delegate = self
            eventTableView.dataSource = self
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return thisDaysEvents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let row = indexPath.row
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Row", for: indexPath)
        let event = thisDaysEvents[row]
        cell.textLabel?.text = event.name
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setActiveDate(activeDate)
    }
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "Show Event Details" {
            if let eventInspector = segue.destination.contents as? EventInspector {
                if let cell = sender as? UITableViewCell, let indexPath = eventTableView.indexPath(for: cell) {
                    let event = thisDaysEvents[indexPath.row]
                    eventInspector.event = event
                    eventInspector.title = event.name
                }
            }
        }
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
}

extension UIViewController {
    var contents: UIViewController {
        if let navcon = self as? UINavigationController {
            return navcon.visibleViewController ?? navcon
        } else {
            return self
        }
    }
}

extension Date {
    func roundedToDay() -> Date {
        let dayComponents = Calendar.current.dateComponents([.year, .month, .day], from: self)
        return Calendar.current.date(from: dayComponents)!
    }
    
    init(year: Int, month: Int, day: Int) {
        let dayComponents = DateComponents(year: year, month: month, day: day)
        self = Calendar.current.date(from: dayComponents)!
    }
}
