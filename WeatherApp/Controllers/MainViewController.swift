//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import WeatherKit
import CoreLocation

class MainViewController: UIViewController {

    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        // Do any additional setup after loading the view.
    }
    
    func startFunc(){
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
    }
    
}

extension MainViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
        guard let location = locations.first else {return}
        weatherManager.getWeather(location: location)
    }
}
