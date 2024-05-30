//
//  RouteRepository.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import CoreData

class RouteRepository
{
    private let _ctxManager: ContextManager;
    private let _localityRepository: LocalityRepository!;
    
    init(contextManager: ContextManager)
    {
        _ctxManager = contextManager;
        _localityRepository = LocalityRepository(contextManager: _ctxManager);
    }
    
    public func GetRoutes()-> [Route]?
    {
        let fetchRequest = NSFetchRequest<Route>(entityName: "Route");
        
        var routes: [Route]? = nil
        
        do{
            try routes = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get all routes request failed with error: \(error)");
        }
        return routes;
    }
    
    public func AddRoute(from: Locality, to: Locality)
    {
        let route = Route(context: _ctxManager.Context);
        route.to = to;
        route.from = from;
        
        do{
            try _ctxManager.SaveChanges();
        } catch let error as NSError{
            print("Failed to save new route: \(route) :error \(error)")
        }
    }
    
    public func GetRoutesFrom(fromLocality: Locality) -> [Route]?
    {
        let routes: [Route]? = fromLocality.routesFrom?.allObjects as! [Route]?;
        return routes;
    }
    
    public func GetRoutesTo(toLocality: Locality) -> [Route]?
    {
        let routes: [Route]? = toLocality.routesTo?.allObjects as! [Route]?;
        return routes;
    }
    
    public func GetRoutesFrom(fromLocalityName: String) -> [Route]?
    {
        let fetchRequest = NSFetchRequest<Route>(entityName: "Route");
        
        let predicate = NSPredicate(format: "from.name == %@", fromLocalityName);
        
        fetchRequest.predicate = predicate;
        
        var routes: [Route]? = nil
        
        do{
            try routes = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get routes by from locality request failed with error: \(error)");
        }
        return routes;
    }
    
    public func GetRoutesTo(toLocalityName: String) -> [Route]?
    {
        let fetchRequest = NSFetchRequest<Route>(entityName: "Route");
        
        let predicate = NSPredicate(format: "to.name == %@", toLocalityName);
        
        fetchRequest.predicate = predicate;
        
        var routes: [Route]? = nil
        
        do{
            try routes = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get routes by to locality name request failed with error: \(error)");
        }
        return routes;
    }
    
    func GetRoute(fromLocalityName: String, toLocalityName: String) -> [Route]?
    {
        let fetchRequest = NSFetchRequest<Route>(entityName: "Route");
        
        let predicate = NSPredicate(format: "to.name == %@ and from.name == %@", toLocalityName, fromLocalityName);
        
        fetchRequest.predicate = predicate;
        
        var routes: [Route]? = nil
        
        do{
            try routes = _ctxManager.Context.fetch(fetchRequest);
            if routes != nil
            {
                print("ROUTES: \(routes)")
            }
        }
        catch let error as NSError{
            print("Get routes by to and from locality name request failed with error: \(error)");
        }
        return routes;
    }
}
