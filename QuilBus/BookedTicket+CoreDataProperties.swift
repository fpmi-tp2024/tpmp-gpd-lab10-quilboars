//
//  BookedTicket+CoreDataProperties.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//
//

import Foundation
import CoreData


extension BookedTicket {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<BookedTicket> {
        return NSFetchRequest<BookedTicket>(entityName: "BookedTicket")
    }

    @NSManaged public var bookingTime: Date?
    @NSManaged public var ride: Ride?
    @NSManaged public var user: User?

}

extension BookedTicket : Identifiable {

}
