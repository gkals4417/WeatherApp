//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import WeatherKit
import CoreLocation

protocol GetWeatherDataDelegate{
    func sendToVC(data: Weather)
}

class MainViewController: UIViewController {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    
    var locationName: String = ""
    var tempWeatherData: Weather! {
        didSet {
            DispatchQueue.main.async {
                self.temperatureLabel.text = "\(self.tempWeatherData.currentWeather.temperature)"
                self.cityLabel.text = self.locationName
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        initialUI()
        // Do any additional setup after loading the view.
    }
    
    func startFunc(){
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        weatherManager.delegate = self
    }
    
    func initialUI(){
        UIGraphicsBeginImageContext(self.view.frame.size)
                    UIImage(named: "background")?.draw(in: self.view.bounds)
                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.view.backgroundColor = UIColor(patternImage: image)
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else {return}
        weatherManager.getWeather(location: location) {}
        lookUpCurrentLocation { result in
            guard let name = result?.name else {return}
            self.locationName = name
        }
    }
    
    
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

extension MainViewController: GetWeatherDataDelegate {
    func sendToVC(data: Weather){
        tempWeatherData = data
    }
}
