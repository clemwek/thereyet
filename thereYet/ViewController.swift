//
//  ViewController.swift
//  thereYet
//
//  Created by Clement Wekesa on 28/03/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import CoreLocation
import MapKit
import UIKit
import UserNotifications

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    var locationManager: CLLocationManager?
    let center = UNUserNotificationCenter.current()
    var location: CLLocation?

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        locationManager?.startUpdatingLocation()

        center.requestAuthorization(options: [.alert, .sound]) { (granted, error) in
            print ("permision was: ", granted)
        }
    }

    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations[locations.count - 1]
        print("location ------->>>>: ", location)
        if let location = location,
            location.horizontalAccuracy > 0 {
            locationManager?.stopUpdatingLocation()
        }
    }

    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error: ", error)
    }
}
