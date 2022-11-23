//
//  MainViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//  Weather

import UIKit
import WeatherKit
import CoreLocation
import SideMenu

protocol GetWeatherDataDelegate{
    func sendToVC(data: Weather)
}

class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    private let weatherManager = WeatherManager.shared
    private let locationManager = CLLocationManager()
    
    var locationName: String = ""
    var name = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startFunc()
        initialUI()
        basicSetupFunc()
    }
    
    private func startFunc(){
        locationManager.startUpdatingLocation()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        weatherManager.delegateReload = self
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func initialUI(){
        UIGraphicsBeginImageContext(self.view.frame.size)
                    UIImage(named: "background2")?.draw(in: self.view.bounds)
                    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
                    UIGraphicsEndImageContext()
                    self.view.backgroundColor = UIColor(patternImage: image)
    }
    
    private func basicSetupFunc(){
        var locationArray: [String] = []
        var removeDuplicateArray: [String] = []
//        var lat: CLLocationDegrees = 0
//        var lon: CLLocationDegrees = 0
        
        weatherManager.savedLocationArray.forEach { result in
            guard let location = result.location else {return}
            locationArray.append(location)
            print("Location Array : \(locationArray)")
            removeDuplicateArray = Array(Set(locationArray))
            print("flatMapped Location Array : \(removeDuplicateArray)")
        }
        
        for location in removeDuplicateArray {
//            self.getCoordinate(addressString: location) { result, error in
//                lat = result.latitude
//                lon = result.longitude
//                DispatchQueue.main.async {
//                    self.weatherManager.getWeatherWithCood(lat: lat, lon: lon) {
//
//                    }
//                }
//            }
            
            self.getCoordinate(addressString: location) { result, error in
                self.weatherManager.getCurrentWeatherWithCood(lat: result.latitude, lon: result.longitude) {
                    
                }
            }
            
            self.collectionView.reloadData()
        }
    }
    @IBAction func locationButtonTapped(_ sender: UIBarButtonItem) {
        lookUpCurrentLocation { result in
            DispatchQueue.main.async {
                guard let location = self.locationManager.location else {return}
                guard let temp = result?.locality else {return}
                self.name = temp
                self.weatherManager.getCurrentWeather(CLlocation: location) {
                    
                }
                self.weatherManager.saveLocationData(location: self.name) {
                    
                }
            }
        }
    }
}

extension MainViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        locationManager.stopUpdatingLocation()
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

extension MainViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherManager.currentWeatherDataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WeatherCell", for: indexPath) as! WeatherCell
        
        DispatchQueue.main.async {
            cell.datas = self.weatherManager.currentWeatherDataArray[indexPath.row]
            cell.cityLabel.text = self.weatherManager.savedLocationArray[indexPath.row].location
        }
//        cell.temperatureLabel.text = "\(weatherManager.currentWeatherDataArray[indexPath.row].temperature)"
//        cell.feelsLikeLabel.text = "\(weatherManager.currentWeatherDataArray[indexPath.row].apparentTemperature)"
//        let tempHumidity = (weatherManager.currentWeatherDataArray[indexPath.row].humidity) * 100
//        cell.humidityLabel.text = String(format: "%.1f", tempHumidity)
//        cell.cityLabel.text = weatherManager.savedLocationArray[indexPath.row].location
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        let itemWidth = collectionView.bounds.width
//        let itemHeight = collectionView.bounds.height
//        return CGSize(width: itemWidth, height: itemHeight)
        let cvRect = collectionView.frame
        return CGSize(width: cvRect.width, height: cvRect.height)
    }
}

extension MainViewController: SideMenuNavigationControllerDelegate {
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        collectionView.reloadData()
    }
}

//extension MainViewController: GetWeatherDataDelegate {
//    func sendToVC(data: Weather){
//        tempWeatherData = data
//    }
//}

extension MainViewController: ScrollDelegate {
    
    func scrollTo(indexPath: IndexPath) {
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.collectionView.reloadData()
        
    }
    
    func views(){
        DispatchQueue.main.async {
            self.collectionView.scrollsToTop = true
            self.collectionView.reloadData()
        }
    }
    
    
}
