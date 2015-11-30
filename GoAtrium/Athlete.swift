//
//  Athlete.swift
//  GoAtrium
//
//  Created by Leo Kwan on 11/29/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

import UIKit


class Athlete: NSObject {
    var firstName: String?
    var lastName: String?
    var sport: String?
    var level: Int?
    
    // custom initializer
    init(firstName:String,lastName:String, sport:String,level:Int) {
        self.firstName = firstName
        self.lastName = lastName
        self.sport = sport
        self.level = level
        
        // call the superclass init last
        super.init()
    }
}
