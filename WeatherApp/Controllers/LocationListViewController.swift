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

    var delegate: ScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.dataSource = self
        locationTableView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        locationSearchBar.delegate = self
        locationSearchBar.placeholder = "영어로 입력하세요."
        
        view.backgroundColor = UIColor(named: "blueWhite")
        
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
        //cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "toDetailVC", sender: indexPath)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailVC" {
            let detailVC = segue.destination as! DetailViewController
            let index = sender as! IndexPath
//            if weatherManager.weatherDatasArray.count > index.row {
//                let list = weatherManager.weatherDatasArray[index.row]
//                detailVC.datas = list
//            }
            DispatchQueue.main.async {
                detailVC.datas = self.weatherManager.weatherDatasArray[index.row]
            }
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            weatherManager.weatherDatasArray.remove(at: indexPath.row)
//            weatherManager.deleteLocation(with: weatherManager.weatherDatasArray[indexPath.row]) {
//                print("DELETE")
//                print("After DELETE WeatherData Array : \(self.weatherManager.weatherDatasArray)")
//                print("After DELETE CoreData Array : \(self.weatherManager.locationSavedArray)")
//            }
            locationTableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
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
//                self.weatherManager.createLocationData(with: self.weatherManager.weatherDatasArray.last!) {
//                    print("weatherDataArray saved in locationListViewController")
//                }
                
                self.locationTableView.reloadData()
                self.dismiss(animated: true)
                self.delegate?.views()
            }
        }
    }
    
    
}

