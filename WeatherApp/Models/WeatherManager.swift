//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreData
import CoreLocation

class WeatherManager{
    static let shared = WeatherManager()
    private init(){
        fetchLocationFromCoreData {
            self.cityNameSavedArray = self.locationSavedArray.map({ result in
                result.location ?? ""
            })
            print("Initial cityNameSavedArray = \(self.cityNameSavedArray)")
            print("Set")
        }
    }
    
    private let networkManager = WeatherNetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    var locationSavedArray: [SavedLocationData] = []
    var cityNameSavedArray: [String] = []
    var weatherDatasArray: [Welcome]? {
        didSet {
            print("weatherDatasArray Set")
        }
    }
    var weatherDatas: Welcome? {
        didSet {
            print("weatherData Set")
        }
    }
    
    // MARK: - API
    
//    func initialFetchDatasFromAPI(lat: CLLocationDegrees, lon: CLLocationDegrees){
//        fetchDatasFromAPI(lat: lat, lon: lon) {
//            print("Initial Setting")
//        }
//    }
    
    
    func fetchDatasFromAPI(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void){
        getDatasFromAPI(lat: lat, lon: lon) {
            completion()
        }
    }
    
    private func getDatasFromAPI(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void){
        networkManager.fetchWeather(latitude: lat, longitude: lon) { result in
            switch result {
            case .success(let successData):
                self.weatherDatas = successData
                self.weatherDatasArray?.append(successData)
//                if !self.cityNameSavedArray.contains(self.weatherDatas!.name){
//                    self.cityNameSavedArray.append(self.weatherDatas!.name)
//                }
//
                print("City Name Saved Array : \(self.cityNameSavedArray)")
                completion()
            case .failure(let error):
                print(error)
                completion()
            }
        }
    }
    
    
    // MARK: - CoreData
  
    func setupBasicFromAPI(completion: @escaping () -> Void){
        getDatasFromAPI(lat: 40, lon: 120) {
            completion()
        }
    }

    
    //READ
    private func fetchLocationFromCoreData(completion: @escaping () -> Void){
        locationSavedArray = coreDataManager.getLocationSavedArrayFromCoreData()
        
//        cityNameSavedArray = locationSavedArray.map({ result in
//            result.location ?? ""
//        })
        completion()
    }
    
    
    //DELETE
    func deleteLocationFromCoreData(with location: SavedLocationData, completion: @escaping () -> Void){
        coreDataManager.deleteLocation(with: location) {
            self.fetchLocationFromCoreData {
                completion()
            }
        }
    }
    
    //UPDATE
    func updateLocationFromCoreData(with location: SavedLocationData, completion: @escaping () -> Void){
        coreDataManager.updateLocation(with: location) {
            self.fetchLocationFromCoreData {
                completion()
            }
        }
    }

    //CREATE
    func createLocationData(with location: Welcome, completion: @escaping () -> Void){
        coreDataManager.saveLocation(with: location, privacyLocation: false, units: "metric") {
            completion()
        }
    }
    
    
    
    func checkWhetherSaved(){
        
    }
    
    
}
