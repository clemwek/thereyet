//
//  MapViewViewModel.swift
//  thereYet
//
//  Created by Clement Wekesa on 21/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import Foundation
import MapKit

class MapViewViewModel {
//    var currentLocation: CLLocation
//    var locationManager: CLLocationManager?
//    var resultSearchController: UISearchController? = nil
//    var selectedPin: MKPlacemark? = nil
//
//    init(<#parameters#>) {
//        <#statements#>
//    }
    
    func setLocalNotification(place: MKMapItem) {
        let content = UNMutableNotificationContent()
        content.title = "Bingo"
        content.body = "You have entered designated area"
        content.sound = .default

        let center = place.placemark.coordinate
        let region = CLCircularRegion(center: center, radius: 500.0, identifier: "New place")
        region.notifyOnEntry = true
        region.notifyOnExit = false

        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)

        let request = UNNotificationRequest(identifier: "destAlarm", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { error in
            if error == nil {
                print("Successful notification")
            } else {
                print(error ?? "Error")
            }
        })
    }
    
}
