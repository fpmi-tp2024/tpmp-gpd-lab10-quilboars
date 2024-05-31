//
//  ContextManager.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import CoreData

class ContextManager
{
    public let Context: NSManagedObjectContext;
    
    init(context: NSManagedObjectContext)
    {
        Context = context;
    }
    
    public func GetContext() -> NSManagedObjectContext {
        return Context;
    }
    
    public func SaveChanges() throws {
        try Context.save();
    }
}
