//
//  Ride+CoreDataProperties.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//
//

import Foundation
import CoreData


extension Ride {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Ride> {
        return NSFetchRequest<Ride>(entityName: "Ride")
    }

    @NSManaged public var arrivalTime: Date?
    @NSManaged public var availableTickets: Int32
    @NSManaged public var departureTime: Date?
    @NSManaged public var duration: Int32
    @NSManaged public var price: Float
    @NSManaged public var bookedTickets: NSSet?
    @NSManaged public var route: Route?

}

// MARK: Generated accessors for bookedTickets
extension Ride {

    @objc(addBookedTicketsObject:)
    @NSManaged public func addToBookedTickets(_ value: BookedTicket)

    @objc(removeBookedTicketsObject:)
    @NSManaged public func removeFromBookedTickets(_ value: BookedTicket)

    @objc(addBookedTickets:)
    @NSManaged public func addToBookedTickets(_ values: NSSet)

    @objc(removeBookedTickets:)
    @NSManaged public func removeFromBookedTickets(_ values: NSSet)

}

extension Ride : Identifiable {

}
