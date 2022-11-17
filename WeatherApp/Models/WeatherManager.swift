//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import WeatherKit
import CoreLocation
import CoreData

protocol ScrollDelegate: AnyObject {
    func views()
}

class WeatherManager: ObservableObject {
    
    static let shared = WeatherManager()
    let coreDataManager = CoreDataManager()
    let weatherService = WeatherService()
    
    private init(){
        savedLocationArray = coreDataManager.readLocation()
        print("WeatherManager Init : \(savedLocationArray)")
    }
    
    var delegateReload: ScrollDelegate?
//    var delegate: GetWeatherDataDelegate?
    var savedLocationArray: [SavedLocationData] = []
    var currentWeatherDataArray: [CurrentWeather] = []{
        didSet {
            print("CurrentWeatherDataArray Changed")
            print(self.currentWeatherDataArray)
            delegateReload?.views()
        }
    }
    
    
//    var weatherData: Weather?{
//        didSet {
//            print("WeatherData Changed Detected")
////            delegate?.sendToVC(data: weatherData)
//            guard let data = weatherData else {return}
//            weatherDataArray.append(data)
//            delegateReload?.views()
//        }
//    }
    
    func getCurrentWeather(CLlocation: CLLocation, completion: @escaping () -> Void){
        Task {
            do {
                let result = try await weatherService.weather(for: CLlocation, including: .current)
                currentWeatherDataArray.insert(result, at: 0)
            } catch {
                print(error)
            }
        }
    }

    
    func getCurrentWeatherWithCood(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void){
        Task {
            do {
                let result = try await weatherService.weather(for: CLLocation.init(latitude: lat, longitude: lon), including: .current)
                currentWeatherDataArray.insert(result, at: 0)
            } catch {
                print(error)
            }
        }
    }
    
    func getLocationArray() -> [SavedLocationData]{
        let temp = savedLocationArray.sorted(by: {$0.savedDate! < $1.savedDate!})
        return temp
    }
    
    func saveLocationData(location: String, completion: @escaping () -> Void){
        coreDataManager.saveLocation(location: location) {
            self.savedLocationArray = self.coreDataManager.readLocation()

            completion()
        }
        
        print("\(#function) : CoreData Saved")
    }
    
    func deleteLocationData(targetData: SavedLocationData, completion: @escaping () -> Void){
        coreDataManager.deleteLocation(data: targetData) {
            self.savedLocationArray = self.coreDataManager.readLocation()
            completion()
        }
        print("\(#function) : CoreData Deleted")
    }
}


