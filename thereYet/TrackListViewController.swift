//
//  TrackListViewController.swift
//  thereYet
//
//  Created by Clement Wekesa on 10/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import CoreData
import UIKit
import CoreLocation

class TrackListViewController: UIViewController {

    @IBOutlet weak var trackTable: UITableView!

//    var places = Places.shared
    var places: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)

        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext

        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Location")

        do {
            places = try managedContext.fetch(fetchRequest)
            trackTable.reloadData()
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        trackTable.reloadData()
    }

     // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         
    }

}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        var description: String = ""
        if place.value(forKey: "placeDescription") != nil {
            description = String(describing: place.value(forKey: "placeDescription")!)
        } else {
            description = "No descripion"
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackListCell", for: indexPath)
        cell.textLabel?.text = "\(String(describing: place.value(forKey: "longitude")!)), \(String(describing: place.value(forKey: "latitude")!))"
        cell.detailTextLabel?.text = description
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Saved Locations"
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let place = places[indexPath.row]
        let location = CLLocation(latitude: place.value(forKey: "latitude")! as! CLLocationDegrees,
                                              longitude: place.value(forKey: "longitude")! as! CLLocationDegrees)
        let mapVC = MapViewController()
        mapVC.currentLoc = location
        let mapView = self.tabBarController?.viewControllers?[0] as? MapViewController
        mapView?.currentLoc = location
        
        // TODO: Pass the selected location to the view controller

        let tab = storyboard?.instantiateInitialViewController() as? TabView
        tab?.selectedIndex = 1
        tab?.selectedViewController = tab?.viewControllers?[0]
        
        present(tab!, animated: true, completion: nil)

    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {

            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            let managedContext =
                appDelegate.persistentContainer.viewContext

            managedContext.delete(places[indexPath.row])
            places.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
