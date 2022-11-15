//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import SideMenu
import WeatherKit
import CoreLocation

class LocationViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    private let weatherManager = WeatherManager.shared
    private let locationManager = CLLocationManager()
    private var delegate: ScrollDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
    }
    
    private func startFunc(){
        tableView.delegate = self
        tableView.dataSource = self
        locationManager.delegate = self
        
        searchBar.delegate = self
        searchBar.placeholder = "도시를 입력하세요."
        
        view.backgroundColor = UIColor(named: "blueWhite")
    }
}

extension LocationViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return weatherManager.weatherDataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "locationCell", for: indexPath)
        var content = cell.defaultContentConfiguration()
        content.text = weatherManager.savedLocationArray[indexPath.row].location
        cell.contentConfiguration = content
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let subject = weatherManager.savedLocationArray[indexPath.row]
            //let anotherSubject = weatherManager.weatherDataArray[indexPath.row]
            weatherManager.savedLocationArray.remove(at: indexPath.row)
            weatherManager.weatherDataArray.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            weatherManager.deleteLocationData(targetData: subject) {
                
            }
            tableView.reloadData()
        } else if editingStyle == .insert {
            
        }
    }
}

extension LocationViewController: CLLocationManagerDelegate {
    
    // MARK: - Coordinate to Placemark name
    
    func lookUpCurrentLocation(completionHandler: @escaping (CLPlacemark?) -> Void ) {
        if let lastLocation = self.locationManager.location {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(lastLocation,
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
        else {
            // No location was available.
            completionHandler(nil)
        }
    }
    
    // MARK: - Placemark name to Coordinate

    func getCoordinate(addressString : String,
            completionHandler: @escaping(CLLocationCoordinate2D, NSError?) -> Void ) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(addressString) { (placemarks, error) in
            if error == nil {
                if let placemark = placemarks?[0] {
                    let location = placemark.location!
                        
                    completionHandler(location.coordinate, nil)
                    return
                }
            }
            completionHandler(kCLLocationCoordinate2DInvalid, error as NSError?)
        }
    }
}

extension LocationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let city = searchBar.text else {return}
        weatherManager.saveLocationData(location: city) {
            print("Location Saved by searchBar")
            self.tableView.reloadData()
            self.delegate?.views()
            self.dismiss(animated: true)
        }
        
        var lat: CLLocationDegrees = 0
        var lon: CLLocationDegrees = 0
        
        getCoordinate(addressString: city) { result, error in
            lat = result.latitude
            lon = result.longitude
            print(lat)
            print(lon)
            
        }
        DispatchQueue.main.async {
            self.weatherManager.getWeatherWithCood(lat: lat, lon: lon) {
                
            }
        }
        
    }
}
