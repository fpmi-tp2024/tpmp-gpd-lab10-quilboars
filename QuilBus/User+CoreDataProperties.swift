//
//  User+CoreDataProperties.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var login: String?
    @NSManaged public var password: String?
    @NSManaged public var role: Int32
    @NSManaged public var bookedTickets: NSSet?

}

// MARK: Generated accessors for bookedTickets
extension User {

    @objc(addBookedTicketsObject:)
    @NSManaged public func addToBookedTickets(_ value: BookedTicket)

    @objc(removeBookedTicketsObject:)
    @NSManaged public func removeFromBookedTickets(_ value: BookedTicket)

    @objc(addBookedTickets:)
    @NSManaged public func addToBookedTickets(_ values: NSSet)

    @objc(removeBookedTickets:)
    @NSManaged public func removeFromBookedTickets(_ values: NSSet)

}

extension User : Identifiable {

}
