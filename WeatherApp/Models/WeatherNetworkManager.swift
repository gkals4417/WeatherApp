//
//  WeatherNetworkManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/05.
//

import Foundation

enum NetworkError: Error {
    case weatherNetworkError
    case weatherDataError
    case weatherParseError
}

struct WeatherNetworkManager {
    
    static let shared = WeatherNetworkManager()
    private init(){}
    
    typealias weatherNetworkCompletion = (Result<Welcome, NetworkError>) -> Void
    
    // MARK: - Fetch Methods
    
    func fetchWeather(latitude: Double, longitude: Double, completion: @escaping weatherNetworkCompletion){
        let urlString = "\(APIconstants.openWeatherURL)?lat=\(latitude)&lon=\(longitude)&units=metric&appid=\(APIconstants.myApiKey)"
        
        getWeather(urlString: urlString) { result in
            completion(result)
        }
    }

    
    // MARK: - GET Methods
    
    private func getWeather(urlString: String, completion: @escaping weatherNetworkCompletion){
        guard let url = URL(string: urlString) else {
            print("ERROR: Cannot Create URL!!!")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: request) { data, response, error in
            if error != nil {
                print(error!)
                completion(.failure(.weatherNetworkError))
                return
            }
            
            guard let safeData = data else {
                print(error!)
                completion(.failure(.weatherDataError))
                return
            }
            
            guard let response = response as? HTTPURLResponse, (200 ..< 299) ~= response.statusCode else {
                print("ERROR: WeatherData Request Error")
                return
            }
            
            if let weatherData = parseJSON(safeData) {
                print("Success WeatherData Parsing")
                completion(.success(weatherData))
            } else {
                print("Failed WeatherData Parsing")
                completion(.failure(.weatherParseError))
            }
        }
        task.resume()
    }
    
    
    // MARK: - Parsing Methods

    private func parseJSON(_ safeData: Data) -> Welcome? {
        do {
            let data = try JSONDecoder().decode(Welcome.self, from: safeData)
            print(data)
            return data
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
}
