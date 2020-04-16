//
//  TrackListViewController.swift
//  thereYet
//
//  Created by Clement Wekesa on 10/04/2020.
//  Copyright © 2020 ddhwty. All rights reserved.
//

import UIKit

class TrackListViewController: UIViewController {

    @IBOutlet weak var trackTable: UITableView!

    var places = Places.shared

    override func viewDidLoad() {
        super.viewDidLoad()
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
        return places.placeList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackListCell", for: indexPath)
        cell.textLabel?.text = places.placeList[indexPath.row].placemark.name ?? "Unknown place"
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            places.placeList.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
}
