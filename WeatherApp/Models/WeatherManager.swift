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
    var weatherDataArray: [Weather] = []{
        didSet {
            print("WeatherDataArray Changed")
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
    
    func getWeather(CLlocation: CLLocation, completion: @escaping () -> Void){
        Task {
            do {
                let result = try await weatherService.weather(for: CLlocation)
                weatherDataArray.append(result)
            } catch {
                print(error)
            }
        }
    }

    
    func getWeatherWithCood(lat: CLLocationDegrees, lon: CLLocationDegrees, completion: @escaping () -> Void){
        Task {
            do {
                let result = try await weatherService.weather(for: .init(latitude: lat, longitude: lon))
                weatherDataArray.append(result)
            } catch {
                print(error)
            }
        }
    }
    
    func getLocationArray() -> [SavedLocationData]{
        return savedLocationArray
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


