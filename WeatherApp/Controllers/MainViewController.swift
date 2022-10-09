//
//  ViewController.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/05.
//

import UIKit
import CoreLocation
import SideMenu


class MainViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    let weatherManager = WeatherManager.shared
    let locationManager = CLLocationManager()
    
    var lon: CLLocationDegrees = 0
    var lat: CLLocationDegrees = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
        
        setupBasicData()
    }
    

    // MARK: - Set Basic Data (Initial Setting)
    
    func setupBasicData(){
        if weatherManager.locationSavedArray.isEmpty {
            weatherManager.fetchDatasFromAPI(lat: 37, lon: 130) {
                print("Hello Swift")
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    self.weatherManager.createLocationData(with: self.weatherManager.weatherDatas!) {
                        print("Saved Basic Location")
                    }
                }
            }
        } else {
            var locationArray:[String] = []
            
            weatherManager.locationSavedArray.forEach { result in
                locationArray.append(result.location ?? "")
                print("Location Array : \(locationArray)")
            }
            for location in locationArray {
                weatherManager.fetchDatasCityNameFromAPI(cityName: location) {
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    // MARK: - @IBAction Methods

    @IBAction func addButtonTapped(_ sender: UIBarButtonItem) {
        weatherManager.fetchDatasFromAPI(lat: lat, lon: lon) {
//              self.weatherManager.weatherDatasArray.append(self.weatherManager.weatherDatas!)
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
                self.weatherManager.createLocationData(with: self.weatherManager.weatherDatasArray.last!) {
                    print("weatherDataArray saved in MainViewController")
                }
            }
        }
    }
}


// MARK: - Extension : CollectionView DataSource & Delegate

extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return weatherManager.weatherDatasArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MainWeatherCollection", for: indexPath) as! WeatherCollectionViewCell
        
        if weatherManager.weatherDatasArray.count > indexPath.row {
            let list = weatherManager.weatherDatasArray[indexPath.row]
            cell.datas = list
        }
        
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
    
    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        performSegue(withIdentifier: "toDetailVC", sender: indexPath)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "toDetailVC"{
//            let detailVC = segue.destination as! DetailViewController
//            let index = sender as! IndexPath
//            DispatchQueue.main.async {
//                detailVC.weatherDescription.text = "날씨 : \(self.weatherManager.weatherDatasArray[index.row].weather[0].weatherDescription)"
//                detailVC.feelsLike.text = "체감 온도 : \(self.weatherManager.weatherDatasArray[index.row].main.feelsLike)"
//                detailVC.pressure.text = "기압 : \(self.weatherManager.weatherDatasArray[index.row].main.pressure)"
//                detailVC.windSpeed.text = "풍속 : \(self.weatherManager.weatherDatasArray[index.row].wind.speed)"
//            }
//        }
//    }
}


// MARK: - Extension : CoreLocation Delegate

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


// MARK: - Extension : SideMenuNavigationControllerDelegate

extension MainViewController: SideMenuNavigationControllerDelegate {
    func sideMenuDidDisappear(menu: SideMenuNavigationController, animated: Bool) {
        collectionView.reloadData()
    }
}

