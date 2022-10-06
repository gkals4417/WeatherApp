//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreData

class WeatherManager{
    static let shared = WeatherManager()
    private init(){
        
    }
    
    private let networkManager = WeatherNetworkManager.shared
    private let coreDataManager = CoreDataManager.shared
    private let locationSavedArray: [SavedLocationData] = []
    
    func getLocationDatasFromCoreData() -> [SavedLocationData]{
        return locationSavedArray
    }
    
}
