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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
}

extension TrackListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let place = places[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackListCell", for: indexPath)
        cell.textLabel?.text = "\(String(describing: place.value(forKey: "longitude")!)), \(String(describing: place.value(forKey: "latitude")!))"
        cell.detailTextLabel?.text = "some text comes here"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
