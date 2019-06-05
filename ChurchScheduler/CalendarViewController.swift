//
//  CalendarViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 5/24/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UITableViewDataSource, URLSessionDownloadDelegate {

    @IBOutlet weak var currentMonthLabel: UILabel!
    @IBAction func didTouchNextMonth(_ sender: UIButton) {
    }
    @IBAction func didTouchPreviousMonth(_ sender: UIButton) {
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.title = "Calendar"
        //downloadService.downloadSession = downloadSession
        
        /*do {
            self.calendarManager = try CalendarManager(urlString: , delegate: self)
        } catch CalendarManagerError.InvalidURL {
            print("urlString for calendar manager is bad")
        } catch {
            print("Some other error")
        }*/
        
        guard let url = URL(string: "http://s3.jamwheeler.com/mvj_scheduler/data2.json") else { print ("DOES NOT WORK"); return}
        
        let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
            print("Starting task")
            print(url)
            if data == nil {
                print(data as Any)
                //throw CalendarManagerError.noDataReturned
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
                //self.calendarView.setNeedsDisplay()

            } catch let parsingError {
                print ("Error")
                print(parsingError)
            }
        }
        task.resume()
        
        setActiveDate(Date())
        
        self.currentMonthLabel.text = "June 2019"
        
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
    
    // Make sure everything is up-to-date when we exit the detail MVC
    override func viewDidDisappear(_ animated: Bool) {
        eventTableView.reloadData()
        calendarView.reloadData()
    }
    
    // Mark: - Model
    
    // https://www.raywenderlich.com/567-urlsession-tutorial-getting-started
    lazy var downloadsSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    var dataTask: URLSessionDataTask?
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        print("Finished downloading to \(location)")
    }
    
    var calendarManager: CalendarManager?
    var eventList = EventList()
    var thisDaysEvents = [Event]()
    var dates = [Date]()
    var activeDate = Date().roundedToDay()
    var displayMonth = 6
    
    
    // Mark: - Collection View
    @IBOutlet weak var calendarView: CalendarView! {
        didSet {
            calendarView.delegate = self
            calendarView.dataSource = self
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("numitems")
        return dates.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Day View Cell", for: indexPath)
        if let calendarDayView = cell as? CalendarDayView {

            let index = indexPath.item
             calendarDayView.delegate = self
            let date = dates[index].roundedToDay()
            calendarDayView.date = date
            calendarDayView.events = eventList.getEventsSameDayAs(date)
            calendarDayView.isInDisplayMonth = (date.month == displayMonth)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Event Row", for: indexPath)
        let event = thisDaysEvents[row]
        cell.textLabel?.text = event.name
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //activeDate.formatter
        //let dateString = "selected date"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMM dd"
        let dateString = dateFormatter.string(from: activeDate)
        return "Events for \(dateString)"
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
    
    var month: Int {
        get {
            return Calendar.current.component(.month, from: self)
        }
    }
    
    init(year: Int, month: Int, day: Int) {
        let dayComponents = DateComponents(year: year, month: month, day: day)
        self = Calendar.current.date(from: dayComponents)!
    }
}
