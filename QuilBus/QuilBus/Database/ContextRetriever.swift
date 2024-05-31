//
//  File.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import UIKit
import CoreData

class ContextRetriever
{
    public static func RetrieveContext()-> NSManagedObjectContext{
        let appDelegate = UIApplication.shared.delegate as! AppDelegate;
        return appDelegate.persistentContainer.viewContext;
    }
}
