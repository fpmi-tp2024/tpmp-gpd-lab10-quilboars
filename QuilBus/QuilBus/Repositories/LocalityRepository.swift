//
//  LocalityRepository.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import CoreData

class LocalityRepository
{
    private let _ctxManager: ContextManager;
    
    init(contextManager: ContextManager){
        _ctxManager = contextManager;
    }
    
    public func GetLocalities()-> [Locality]?
    {
        let fetchRequest = NSFetchRequest<Locality>(entityName: "Locality");
        
        var localities: [Locality]? = nil
        
        do{
            try localities = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get all localities request failed with error: \(error)");
        }
        return localities;
    }
    
    public func AddLocality(name: String, latitude: Double, longitude: Double)
    {
        let locality = Locality(context: _ctxManager.Context);
        locality.name = name;
        locality.latitude = latitude;
        locality.longitude = longitude;
        
        do{
            try _ctxManager.SaveChanges();
        } catch let error as NSError{
            print("Failed to save new locality: \(locality) :error \(error)")
        }
    }
    
    public func GetLocalityByName(name: String) -> [Locality]?
    {
        let fetchRequest = NSFetchRequest<Locality>(entityName: "Locality");
        
        let predicate = NSPredicate(format: "name == %@", name);
        
        fetchRequest.predicate = predicate;
        
        var locality: [Locality]? = nil
        
        do{
            try locality = _ctxManager.Context.fetch(fetchRequest);
            print("request done")
        }
        catch let error as NSError{
            print("Get locality by name request failed with error: \(error)");
        }
        return locality;
    }
}
