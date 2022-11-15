//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/11.
//

import UIKit
import WeatherKit
import CoreLocation

class WeatherCell: UICollectionViewCell {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var feelsLikeLabel: UILabel!
    
    
    private let locationManager = CLLocationManager()
    private let weatherManager = WeatherManager.shared
    
    var datas: Weather?{
        didSet {
            configureCell()
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
    
    func configureCell(){
        guard let datas = datas else {return}
//        cityLabel.text = "\(datas.currentWeather.metadata.location)"
        temperatureLabel.text = "\(datas.currentWeather.temperature)"
        feelsLikeLabel.text = "\(datas.currentWeather.apparentTemperature)"
        humidityLabel.text = "\(datas.currentWeather.humidity)"
    }

}
