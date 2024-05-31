//
//  UserRepository.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation
import CoreData

class UserRepository
{
    private let _ctxManager: ContextManager;
    
    init(contextManager: ContextManager){
        _ctxManager = contextManager;
    }
    public func GetAllUsers()-> [User]?
    {
        let fetchRequest = NSFetchRequest<User>(entityName: "User");
        
        var users: [User]? = nil
        
        do{
            try users = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get all user request failed with error: \(error)");
        }
        return users;
    }
    
    public func AddUser(login: String, password: String, role: Role = Role.Default) -> User?
    {
        let user = User(context: _ctxManager.Context);
        user.login = login;
        user.password = password;
        user.role = Int32(role.rawValue);
        
        do{
            try _ctxManager.SaveChanges();
        } catch let error as NSError{
            print("Failed to save new user: \(user) :error \(error)")
            return nil
        }
        return user
    }
    
    public func GetUsersByLogin(login: String) -> [User]?
    {
        let fetchRequest = NSFetchRequest<User>(entityName: "User");
        
        let predicate = NSPredicate(format: "login == %@", login);
        
        fetchRequest.predicate = predicate;
        
        var users: [User]? = nil
        
        do{
            try users = _ctxManager.Context.fetch(fetchRequest);
        }
        catch let error as NSError{
            print("Get all user request failed with error: \(error)");
        }
        return users;
    }
}
