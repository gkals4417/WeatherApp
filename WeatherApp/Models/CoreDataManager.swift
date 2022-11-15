//
//  CoreDataManager.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/11.
//

import UIKit
import CoreData

class CoreDataManager {
    let appDelegate = UIApplication.shared.delegate as? AppDelegate
    lazy var context = appDelegate?.persistentContainer.viewContext
    let modelName: String = "SavedLocationData"
    
    // MARK: - READ
    
    func readLocation() -> [SavedLocationData]{
        var array: [SavedLocationData] = []
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            let dataOrder = NSSortDescriptor(key: "savedDate", ascending: false)
            request.sortDescriptors = [dataOrder]
            
            do {
                if let fetched = try context.fetch(request) as? [SavedLocationData]{
                    array = fetched
                }
            } catch {
                print("Failed Read")
            }
        }
        return array
    }

    
    
    // MARK: - SAVE
    
    func saveLocation(location: String, completion: @escaping () -> Void){
        if let context = context {
            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context){
                if let saveTarget = NSManagedObject(entity: entity, insertInto: context) as? SavedLocationData {
                    saveTarget.location = location
                    saveTarget.savedDate = Date()
                    
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
    }

    // MARK: - DELETE
    
    func deleteLocation(data: SavedLocationData, completion: @escaping () -> Void){
        guard let date = data.savedDate else {
            completion()
            return
        }
        
        if let context = context {
            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
            request.predicate = NSPredicate(format: "savedDate = %@", date as CVarArg)
            
            do {
                if let fetched = try context.fetch(request) as? [SavedLocationData]{
                    if let target = fetched.first{
                        context.delete(target)
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
                completion()
            } catch {
                print("Failed Delete")
                completion()
            }
        }
    }

}
