//
//  PasswordComparer.swift
//  QuilBus
//
//  Created by Michael Romanov on 5/29/24.
//

import Foundation

class PasswordComparer
{
    public static func Compare(coming: String?, stored: String?) -> Bool{
        
        if(coming == nil || stored == nil)
        {
            return false;
        }
        
        let hashed = String(coming!.hash);
        
        if(hashed == stored){
            return true;
        }
        
        return false;
    }
}
