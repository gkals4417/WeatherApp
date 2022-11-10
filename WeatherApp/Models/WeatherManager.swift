//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import UIKit
import WeatherKit
import CoreLocation

class WeatherManager: ObservableObject {
    
    static let shared = WeatherManager()
    
    let weatherService = WeatherService()

    
    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await weatherService.weather(for: location)
                print(result.currentWeather.temperature)
            } catch {
                
            }
        }
    }
}
