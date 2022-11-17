//
//  SavedLocationData+CoreDataProperties.swift
//  WeatherApp
//
//  Created by Hamin Jeong on 2022/11/11.
//
//

import Foundation
import CoreData


extension SavedLocationData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<SavedLocationData> {
        return NSFetchRequest<SavedLocationData>(entityName: "SavedLocationData")
    }

    @NSManaged public var location: String?
    @NSManaged public var savedDate: Date?

}

extension SavedLocationData : Identifiable {

}
