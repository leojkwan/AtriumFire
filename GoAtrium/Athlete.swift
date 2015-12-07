//
//  Athlete.swift
//  GoAtrium
//
//  Created by Leo Kwan on 11/29/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

import UIKit
import Firebase

public enum Name {
    case firstName
    case lastName
}


struct Athlete {
    // required
    let uid: String
    let email: String
    let displayname: String
    
     // optional values
    var sport: Sport?
    
    // Convenience initializer with FB auth object.
    init(authData: FAuthData) {
        uid = authData.uid
        email = authData.providerData["email"] as! String
        displayname = authData.providerData["displayName"] as! String
    }
    
    // Create a dictionary with this object
    func toAnyObject()-> AnyObject {
        return [
        "fbUserId": uid,
        "email": email,
        "firstName": self.getNamePart(.firstName),
        "lastName": self.getNamePart(.lastName)
        ]
    }
    
    // Get part of user name.
    func getNamePart(partOfName:Name)-> String {
        let parts = displayname.componentsSeparatedByString(" ")
        switch partOfName{
        case.firstName: return parts[0]
        case .lastName: return parts[1]
        }
    }
}
