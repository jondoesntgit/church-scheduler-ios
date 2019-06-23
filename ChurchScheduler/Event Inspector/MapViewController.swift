//
//  MapViewController.swift
//  ChurchScheduler
//
//  Created by Jonathan Wheeler on 6/2/19.
//  Copyright © 2019 Jonathan Wheeler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate {
    
    private struct Storyboard {
        static let unwindToEventInspector = "Unwind to Event Inspector"
    }
    
    private struct Constants {
        static let coordinateSpan = 0.05
        static let minimumPressDuration = 0.5
    }
    
    @IBOutlet weak var mapView: MKMapView!
    var annotation: MKPointAnnotation?
    var parentController: EventInspector!
    let locationManager = CLLocationManager()
    
    @IBAction func didTouchCancelButton(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: Storyboard.unwindToEventInspector, sender: sender)
    }
    
    @IBAction func didTouchSaveButton(_ sender: UIBarButtonItem) {
        // TODO: Actually save it
        if let coordinate = annotation?.coordinate {
            parentController.event.latitude = coordinate.latitude
            parentController.event.longitude = coordinate.longitude
        }

        performSegue(withIdentifier: Storyboard.unwindToEventInspector, sender: sender)
    }
    
    @objc func handleLongPress(_ gestureRecognizer: UIGestureRecognizer) {
        // https://stackoverflow.com/a/29466391/3635467
        if gestureRecognizer.state != .began { return }
        let touchPoint = gestureRecognizer.location(in: mapView)
        let touchMapCoordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
        
        if annotation == nil {
            annotation = MKPointAnnotation()
            mapView.addAnnotation(annotation!)
        }
        annotation!.coordinate = touchMapCoordinate
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.handleLongPress(_:)))
        longPressRecognizer.minimumPressDuration = Constants.minimumPressDuration
        
        // Only allow user to set location if they are an Admin
        if Globals.isAdmin {
            mapView.addGestureRecognizer(longPressRecognizer)
        }
        mapView.mapType = MKMapType.standard
        
        //https://stackoverflow.com/a/25698536/3635467
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        // https://www.raywenderlich.com/548-mapkit-tutorial-getting-started
        
        if let eventLatitude = parentController.event.latitude {
            if let eventLongitude = parentController.event.longitude {
                let eventCoordinate = CLLocationCoordinate2D(latitude: eventLatitude, longitude: eventLongitude)
                annotation = MKPointAnnotation()
                annotation!.coordinate = eventCoordinate
                mapView.addAnnotation(annotation!)
            }
        }
        
        if let location = locationManager.location {
            let span = MKCoordinateSpan(latitudeDelta: Constants.coordinateSpan, longitudeDelta: Constants.coordinateSpan)
            let region = MKCoordinateRegion(center: location.coordinate, span: span)
            mapView.setRegion(region, animated: true)
        }

    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location: CLLocationCoordinate2D = locationManager.location?.coordinate else {return}
        print(location)
    }

}
