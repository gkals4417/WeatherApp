//
//  ViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/05.
//

import UIKit
import CoreLocation


class MainViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    var lon: CLLocationDegrees = 0
    var lat: CLLocationDegrees = 0
    var tempWeatherData: Welcome?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        setupBasicData()
    }
    
    func setupBasicData(){
        weatherManager.fetchDatasFromAPI(lat: 37, lon: 130) {
            print("Hello")
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.weatherManager.createLocationData(with: self.weatherManager.weatherDatas!) {
                    print("Saved Basic Location")
                }
            }
        }
    }
    
    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        weatherManager.fetchDatasFromAPI(lat: lat, lon: lon) {
            self.weatherManager.cityNameSavedArray.append(self.weatherManager.weatherDatas!.name)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
}

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return weatherManager.cityNameSavedArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainWeatherCollection", for: indexPath) as! WeatherCollectionViewCell
        
        let welcomeData = weatherManager.weatherDatas
        
        cell.datas = welcomeData
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

//                //For entire screen size
//                let screenSize = UIScreen.main.bounds.size
//                return screenSize
//                //If you want to fit the size with the size of ViewController use bellow
//                let viewControllerSize = self.view.frame.size
//                return viewControllerSize
//
//                // Even you can set the cell to uicollectionview size
//                let cvRect = collectionView.frame
//                return CGSize(width: cvRect.width, height: cvRect.height)

        let cvRect = collectionView.frame
        return CGSize(width: cvRect.width, height: cvRect.height)
    }
    
}

extension MainViewController: CLLocationManagerDelegate{
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
