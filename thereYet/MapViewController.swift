//
//  ViewController.swift
//  thereYet
//
//  Created by Clement Wekesa on 28/03/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import CoreData
import MapKit
import UIKit
import UserNotifications


protocol HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark)
    func showAlert(place: MKMapItem)
}


class MapViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    var currentLoc: CLLocation!
    var locationManager: CLLocationManager?
    var resultSearchController: UISearchController? = nil
    var selectedPin: MKPlacemark? = nil
    let veiwModel = MapViewViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Setup location manager and request for permisions track user location
        locationManager = CLLocationManager()
        locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        locationManager?.delegate = self
        locationManager?.requestAlwaysAuthorization()

        // Start tracking location
        locationManager?.startUpdatingLocation()

        //  Show current location in map
        //        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        //            CLLocationManager.authorizationStatus() == .authorizedAlways) {
        //
        //            currentLoc = locationManager?.location
        //            let region = MKCoordinateRegion(center: currentLoc.coordinate,
        //                                            latitudinalMeters: 50000,
        //                                            longitudinalMeters: 60000)
        //            mapView.setCameraBoundary(
        //                MKMapView.CameraBoundary(coordinateRegion: region),
        //                animated: true)
        //
        //            let zoomRange = MKMapView.CameraZoomRange(maxCenterCoordinateDistance: 200000)
        //            mapView.setCameraZoomRange(zoomRange, animated: true)
        //
        //            mapView.centerToLocation(currentLoc)
        //        }
        
        setupSearchTable()

        // Add gesture information
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        gestureRecognizer.delegate = self
        mapView.addGestureRecognizer(gestureRecognizer)
        
        UNUserNotificationCenter.current().getPendingNotificationRequests(completionHandler: { (requests) in

            for request in requests {
                
                print("------------------->>>>>>>>>>>>>>", request)
                
                //                if request.identifier == "IDENTIFIER YOU'RE CHECKING IF EXISTS" {
                //
                //                    //Notification already exists. Do stuff.
                //
                //                } else if request === requests.last {
                //
                //                    //All requests have already been checked and notification with identifier wasn't found. Do stuff.
                //
                //                }
            }
        })
    }

    @objc
    func handleTap(_ gestureReconizer: UILongPressGestureRecognizer) {
        let cgLocation = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(cgLocation, toCoordinateFrom: mapView)
        let location = CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)

        lookUpCurrentLocation(location: location) { (placemark) in
            if let placemark = placemark {
                self.showAlert(place: MKMapItem(placemark: MKPlacemark(placemark: placemark)))
            }
        }
    }

    // This looks up the tapped location and adds description
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (CLPlacemark?) -> Void) {
        let geocoder = CLGeocoder()

        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location,
                                        completionHandler: { (placemarks, error) in
                                            if error == nil {
                                                let firstLocation = placemarks?[0]
                                                completionHandler(firstLocation)
                                            }
                                            else {
                                                // An error occurred during geocoding.
                                                completionHandler(nil)
                                            }
        })
    }

    func setupSearchTable() {
        // Setup the search table
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable

        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places"
        navigationItem.titleView = resultSearchController?.searchBar

        resultSearchController?.hidesNavigationBarDuringPresentation = false
        resultSearchController?.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true

        locationSearchTable.mapView = mapView

        locationSearchTable.handleMapSearchDelegate = self
    }

    func addAnnotation(coordinate: CLLocationCoordinate2D) {
        // Add annotation:
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        mapView.addAnnotation(annotation)
    }

    func save(place: MKPlacemark) {

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }

        let managedContext =
            appDelegate.persistentContainer.viewContext

        let entity =
            NSEntityDescription.entity(forEntityName: "Location",
                                       in: managedContext)!

        let location = NSManagedObject(entity: entity,
                                       insertInto: managedContext)

        location.setValue(place.coordinate.latitude, forKeyPath: "latitude")
        location.setValue(place.coordinate.longitude, forKeyPath: "longitude")
        location.setValue(self.parseAddress(selectedItem: place), forKey: "placeDescription")

        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
}

extension MapViewController: CLLocationManagerDelegate {
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last,
            location.horizontalAccuracy > 0 {
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            self.mapView.setRegion(region, animated: true)
            locationManager?.stopUpdatingLocation()
        }
    }
    
    //Write the didFailWithError method here:
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("There was an error: ", error)
    }
}

extension MapViewController: HandleMapSearch {
    func dropPinZoomIn(placemark: MKPlacemark) {
        // cache the pin
        selectedPin = placemark
        // clear existing pins
        mapView.removeAnnotations(mapView.annotations)
        let annotation = MKPointAnnotation()
        annotation.coordinate = placemark.coordinate
        annotation.title = placemark.name
        if let city = placemark.locality,
            let state = placemark.administrativeArea {
            annotation.subtitle = "\(city) \(state)"
        }
        mapView.addAnnotation(annotation)
        let span = MKCoordinateSpan(latitudeDelta: 0.005, longitudeDelta: 0.005)
        let region = MKCoordinateRegion(center: placemark.coordinate, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    func showAlert(place: MKMapItem) {
        let alertController = UIAlertController(title: "Do you what to save this location",
                                                message: "If you save this location you will be notified when enter the region of a 1Km radius",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Dismis", style: .cancel, handler: nil))
        alertController.addAction(UIAlertAction(title: "Save", style: .default, handler: { (action) in
            self.veiwModel.setLocalNotification(place: place)
            self.addAnnotation(coordinate: place.placemark.coordinate)
            self.save(place: place.placemark)
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func parseAddress(selectedItem: MKPlacemark) -> String {
        // put a space between "4" and "Melrose Place"
        let firstSpace = (selectedItem.subThoroughfare != nil && selectedItem.thoroughfare != nil) ? " " : ""
        // put a comma between street and city/state
        let comma = (selectedItem.subThoroughfare != nil || selectedItem.thoroughfare != nil) && (selectedItem.subAdministrativeArea != nil || selectedItem.administrativeArea != nil) ? ", " : ""
        // put a space between "Washington" and "DC"
        let secondSpace = (selectedItem.subAdministrativeArea != nil && selectedItem.administrativeArea != nil) ? " " : ""
        let addressLine = String(
            format:"%@%@%@%@%@%@%@",
            // street number
            selectedItem.subThoroughfare ?? "",
            firstSpace,
            // street name
            selectedItem.thoroughfare ?? "",
            comma,
            // city
            selectedItem.locality ?? "",
            secondSpace,
            // state
            selectedItem.administrativeArea ?? ""
        )
        return addressLine
    }
}

private extension MKMapView {
    func centerToLocation(
        _ location: CLLocation,
        regionRadius: CLLocationDistance = 1000
    ) {
        let coordinateRegion = MKCoordinateRegion(
            center: location.coordinate,
            latitudinalMeters: regionRadius,
            longitudinalMeters: regionRadius)
        setRegion(coordinateRegion, animated: true)
    }
}

extension MapViewController : MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?{
        if annotation is MKUserLocation {
            //return nil so map view draws "blue dot" for standard user location
            return nil
        }
        let reuseId = "pin"
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
        pinView?.pinTintColor = UIColor.orange
        pinView?.canShowCallout = true
        return pinView
    }
}
