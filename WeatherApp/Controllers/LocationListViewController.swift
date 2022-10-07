//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreLocation

class LocationListViewController: UIViewController {

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!
    
    let weatherManager = WeatherManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.dataSource = self
        locationTableView.delegate = self
    }
    

}

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherManager.cityNameSavedArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "LocationListCell", for: indexPath) as! LocationListCell
        cell.textLabel?.text = weatherManager.cityNameSavedArray[indexPath.row]
        
        return cell
    }
    
    
}
