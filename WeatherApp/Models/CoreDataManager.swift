//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/10/06.
//

import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init(){}
    
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    lazy var context = appDelegate?.persistentContainer.viewContext
    
    let modelName: String = "WeatherApp"
    
    // MARK: - CREATE
    
    func saveLocation(with location: String, privacyLocation: Bool, units: String, completion: @escaping () -> Void){
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context){
                if let locationSaved = NSManagedObject(entity: entity, insertInto: context) as? SavedLocationData {
                    locationSaved.location = location
                    locationSaved.privacyLocation = privacyLocation
                    locationSaved.units = units
                    
                    if context.hasChanges {
                        do {
                            try context.save()
                            completion()
                        } catch {
                            print(error)
                            completion()
                        }
                    }
                }
            }
        }
        completion()
    }
    
    
    // MARK: - READ
    
    func getLocationSavedArrayFromCoreData() -> [SavedLocationData]{
        var savedLocationList: [SavedLocationData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let savedDate = NSSortDescriptor(key: "savedDate", ascending: true)
            request.sortDescriptors = [savedDate]
            
            do {
                if let fetchedLocationList = try context.fetch(request) as? [SavedLocationData]{
                    savedLocationList = fetchedLocationList
                }
            } catch {
                print("Failed Fetched Location List")
            }
        }
        return savedLocationList
    }
    
    
    // MARK: - UPDATE
    
    func updateLocation(with location: SavedLocationData, completion: @escaping () -> Void){
        guard let savedDate = location.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                if let fetchedLocationList = try context.fetch(request) as? [SavedLocationData]{
                    if var targetLocation = fetchedLocationList.first{
                        
                        targetLocation = location
                        
                        if context.hasChanges{
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Failed Update Location")
                completion()
            }
        }
    }
    
    
    
    
    
    // MARK: - DELETE
    
    func deleteLocation(with location: SavedLocationData, completion: @escaping () -> Void){
        guard let savedDate = location.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", savedDate as CVarArg)
            
            do {
                if let fetchedLocationList = try context.fetch(request) as? [SavedLocationData]{
                    if let targetLocation = fetchedLocationList.first{
                        context.delete(targetLocation)
                        if context.hasChanges{
                            do {
                                try context.save()
                                completion()
                            } catch {
                                print(error)
                                completion()
                            }
                        }
                    }
                }
                completion()
            } catch {
                print("Failed Delete Location")
                completion()
            }
        }
    }
    
    
    
    

}
