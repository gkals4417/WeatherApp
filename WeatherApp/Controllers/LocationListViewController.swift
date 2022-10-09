//
//  LocationListViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreLocation
import SideMenu

class LocationListViewController: UIViewController {

    @IBOutlet weak var locationSearchBar: UISearchBar!
    @IBOutlet weak var locationTableView: UITableView!

    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    
    var lat: CLLocationDegrees = 0
    var lon: CLLocationDegrees = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        locationSearchBar.delegate = self
        locationSearchBar.placeholder = "영어로 입력하세요."
    }
}


// MARK: - Extension : UITableView DataSource & Delegate

extension LocationListViewController: UITableViewDataSource, UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherManager.weatherDatasArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = locationTableView.dequeueReusableCell(withIdentifier: "LocationListCell", for: indexPath) as! LocationListCell
        cell.textLabel?.text = weatherManager.weatherDatasArray[indexPath.row].name
        cell.selectionStyle = .none
        return cell
    }
}


// MARK: - Extension : CoreLocation Delegate

extension LocationListViewController: CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        locationManager.stopUpdatingLocation()
        lat = location.coordinate.latitude
        lon = location.coordinate.longitude
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
    }
}


// MARK: - Extension : UISearchBar Delegate

extension LocationListViewController: UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = locationSearchBar.text else {return}
        weatherManager.fetchDatasCityNameFromAPI(cityName: city) {
            
            DispatchQueue.main.async {
                self.locationTableView.reloadData()
                self.weatherManager.createLocationData(with: self.weatherManager.weatherDatasArray.last!) {
                    print("weatherDataArray saved in locationListViewController")
                }
                self.dismiss(animated: true)
                
            }
        }
        
    }
}

