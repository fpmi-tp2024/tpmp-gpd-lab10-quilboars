//
//  Route+CoreDataProperties.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//
//

import Foundation
import CoreData


extension Route {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Route> {
        return NSFetchRequest<Route>(entityName: "Route")
    }

    @NSManaged public var from: Locality?
    @NSManaged public var rides: NSSet?
    @NSManaged public var to: Locality?

}

// MARK: Generated accessors for rides
extension Route {

    @objc(addRidesObject:)
    @NSManaged public func addToRides(_ value: Ride)

    @objc(removeRidesObject:)
    @NSManaged public func removeFromRides(_ value: Ride)

    @objc(addRides:)
    @NSManaged public func addToRides(_ values: NSSet)

    @objc(removeRides:)
    @NSManaged public func removeFromRides(_ values: NSSet)

}

extension Route : Identifiable {

}
