//
//  Locality+CoreDataProperties.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//
//

import Foundation
import CoreData


extension Locality {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locality> {
        return NSFetchRequest<Locality>(entityName: "Locality")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var name: String?
    @NSManaged public var routesFrom: NSSet?
    @NSManaged public var routesTo: NSSet?

}

// MARK: Generated accessors for routesFrom
extension Locality {

    @objc(addRoutesFromObject:)
    @NSManaged public func addToRoutesFrom(_ value: Route)

    @objc(removeRoutesFromObject:)
    @NSManaged public func removeFromRoutesFrom(_ value: Route)

    @objc(addRoutesFrom:)
    @NSManaged public func addToRoutesFrom(_ values: NSSet)

    @objc(removeRoutesFrom:)
    @NSManaged public func removeFromRoutesFrom(_ values: NSSet)

}

// MARK: Generated accessors for routesTo
extension Locality {

    @objc(addRoutesToObject:)
    @NSManaged public func addToRoutesTo(_ value: Route)

    @objc(removeRoutesToObject:)
    @NSManaged public func removeFromRoutesTo(_ value: Route)

    @objc(addRoutesTo:)
    @NSManaged public func addToRoutesTo(_ values: NSSet)

    @objc(removeRoutesTo:)
    @NSManaged public func removeFromRoutesTo(_ values: NSSet)

}

extension Locality : Identifiable {

}
