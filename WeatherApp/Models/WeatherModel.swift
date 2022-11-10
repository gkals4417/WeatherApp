//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/10.
//

import Foundation

struct WeatherModel {
    
    struct CurrentWeather {
        let condition: String
        let symbolName: String
        let humidity: Double
        let temperature: Double
        let apperentTemperature: Double
        let wind: Double
    }
}
