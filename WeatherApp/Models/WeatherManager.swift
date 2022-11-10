//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import WeatherKit
import CoreLocation



class WeatherManager {
    
    static let shared = WeatherManager()
    
    var delegate: GetWeatherDataDelegate?
    let weatherService = WeatherService()
    var weatherData: Weather!{
        didSet {
            print("WeatherData Changed Detected")
            delegate?.sendToVC(data: weatherData)
        }
    }
    
    func getWeather(location: CLLocation, completion: @escaping () -> Void){
        Task {
            do {
                let result = try await weatherService.weather(for: location)
                weatherData = result
            } catch {
                print(error)
            }
        }
    }
}


