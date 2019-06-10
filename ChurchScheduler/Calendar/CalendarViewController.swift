//
//  CalendarViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/24/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource {
    
    private struct Storyboard {
        static let showEventDetails = "Show Event Details"
        static let dayViewCell = "Day View Cell"
        static let eventRow = "Event Row"
    }
    
    private struct Constants {
        static let navigationControllerTitle = "Calendar"
    }
    

    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBAction func didTouchNextMonth(_ sender: UIButton) {
        if activeMonth.month! == 12 {
            activeMonth.month! = 1
            activeMonth.year! += 1
        } else {
            activeMonth.month! += 1
        }
    }
    @IBAction func didTouchPreviousMonth(_ sender: UIButton) {
        if activeMonth.month == 1 {
            activeMonth.month! = 12
            activeMonth.year! -= 1
        } else {
            activeMonth.month! -= 1
        }
    }
    
    // MARK: - Controller Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        self.navigationController?.title = Constants.navigationControllerTitle
        
        let url = Globals.dataSourceURL
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            if data == nil {
                self.offerToLoadDummyData(withTitle: "No Data Received")
                return
            }
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .iso8601
                let events = try decoder.decode([Event].self, from: data!)
                for event in events {
                    self.eventList.add(event)
                }
                DispatchQueue.main.async {
                    self.calendarView.reloadData()
                }

            } catch _ {
                self.offerToLoadDummyData(withTitle: "Invalid JSON received")
            }
        }
        task.resume()
        
        let currentDate = Date()
        
        activeMonth = Calendar.current.dateComponents([.year, .month], from: currentDate)
        fillDatesForCurrentMonth()
        setActiveDate(currentDate)
    }
    
    // Make sure everything is up-to-date when we exit the detail MVC
    override func viewDidDisappear(_ animated: Bool) {
        eventTableView.reloadData()
        calendarView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setActiveDate(activeDate)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        for cell in calendarView.visibleCells {
            cell.setNeedsDisplay()
        }
        calendarView.setActiveCellByDate(activeDate)
        calendarView.setNeedsDisplay()
    }
    
    
    // MARK: - Model
    
    var eventList = EventList()
    var thisDaysEvents = [Event]()
    var dates = [Date]()
    var activeDate = Date().roundedToDay()
    var activeMonth: DateComponents! {
        didSet {
            fillDatesForCurrentMonth()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM YYYY"
            let activeMonthAsDate = Calendar.current.date(from: activeMonth)!
            currentMonthLabel.text = dateFormatter.string(from: activeMonthAsDate)
            calendarView.reloadData()
            calendarView.setNeedsLayout()
            calendarView.setNeedsDisplay()
            setActiveDate(activeMonthAsDate)
        }
    }
    
    
    // MARK: - Collection View
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
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Storyboard.dayViewCell, for: indexPath)
        if let calendarDayView = cell as? CalendarDayView {

            let index = indexPath.item
             calendarDayView.delegate = self
            let date = dates[index].roundedToDay()
            calendarDayView.date = date
            calendarDayView.events = eventList.getEventsSameDayAs(date)
            calendarDayView.isInDisplayMonth = (date.month == activeMonth.month)
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
        eventTableView.setNeedsDisplay()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.eventRow, for: indexPath)
        let event = thisDaysEvents[row]
        cell.textLabel?.text = event.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM d"
        let dateString = dateFormatter.string(from: activeDate)
        return "Events for \(dateString)"
    }
    
    // MARK: - Calendar Arithmetic
    
    func fillDatesForCurrentMonth() {
        dates = []
        var components = activeMonth!
        components.day = 1
        //let firstDayOfMonth = Calendar.current.nextDate(after: self, matching: activeMonth, matchingPolicy: .previousTimePreservingSmallerComponents, direction: .backward)!
        let firstDayOfMonth = Calendar.current.date(from: components)!
        let firstSundayOfMonth = Calendar.current.date(bySetting: .weekday, value: 1, of: firstDayOfMonth)!
        let firstSundayOfCalendar = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: firstSundayOfMonth, wrappingComponents: false)!
        var workingDate = Calendar.current.startOfDay(for: firstSundayOfCalendar)
        
        let numberOfDaysToDisplay = 6 * 7 // six weeks, 42 days
        for _ in 1...numberOfDaysToDisplay {
            dates.append(workingDate)
            workingDate = workingDate.nextDay()
        }
    }
    
    func offerToLoadDummyData(withTitle title: String) {
        let alertMessage = UIAlertController(title: title, message: "Sorry, no data could be downloaded from the event server. Would you like to use some hard-coded data instead?", preferredStyle: .alert)
        alertMessage.addAction(UIAlertAction(title: "Cancel", style: .default, handler: nil))
        alertMessage.addAction(UIAlertAction(title: "OK", style: .default) { alertAction in
            let eventOne = Event(name: "Hard-coded event 1")
            let eventTwo = Event(name: "Hard-coded event 2")
            let eventThree = Event(name: "Hard-coded event 3")
            
            eventOne.startTime = Date()
            eventTwo.startTime = Date().addingTimeInterval(3600.0)
            eventThree.startTime = Date().addingTimeInterval(86400.0)
            
            eventOne.components.append(EventComponent(withLeftText: "Part 1", withRightText: "Person 1", withCenterText: nil))
            eventOne.components.append(EventComponent(withLeftText: "Part 2", withRightText: "Person 2", withCenterText: nil))
            eventOne.components.append(EventComponent(withLeftText: "Part 3", withRightText: "Person 3", withCenterText: nil))
            eventThree.components.append(EventComponent(withLeftText: "Segment 1", withRightText: "Person 1", withCenterText: nil))
            
            self.eventList.add(eventOne)
            self.eventList.add(eventTwo)
            self.eventList.add(eventThree)
            DispatchQueue.main.async {
                self.calendarView.reloadData()
                for cell in self.calendarView.visibleCells {
                    cell.setNeedsDisplay()
                }
                self.calendarView.setNeedsDisplay()
                self.setActiveDate(self.activeDate)
            }
        })
        
        self.present(alertMessage, animated: true, completion: nil)
    }
    
    // MARK: - Navigation

    //In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == Storyboard.showEventDetails {
            if let eventInspector = segue.destination.contents as? EventInspector {
                if let cell = sender as? UITableViewCell, let indexPath = eventTableView.indexPath(for: cell) {
                    let event = thisDaysEvents[indexPath.row]
                    eventInspector.event = event
                    eventInspector.title = event.name
                }
            }
        }
    }
}
