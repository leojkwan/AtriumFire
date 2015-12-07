//
//  ViewController.swift
//  GoAtrium
//
//  Created by Leo Kwan on 11/28/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var displayNameLabel: UILabel!
    
    var currentUser:Athlete!
    
    // base url for users
    let userbaseRef = Firebase(url: "https://goatrium.firebaseio.com/userbase")
    var currentUserRef: Firebase!
    var userInfoRef: Firebase!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /**
        * SET USER PROPERTY WITH FB AUTH DATA
        */
        
        userbaseRef.observeAuthEventWithBlock { authData in
            
            // Create a child reference with FB user id
            self.currentUser = Athlete(authData: authData)
            self.displayNameLabel.text = self.currentUser.displayname
            
            // Path for online users.
            if let currentUser = self.userbaseRef.childByAppendingPath(self.currentUser.displayname) {
                self.currentUserRef = currentUser;
                self.currentUserRef.setValue(self.currentUser.email)
            }
            // Path for current user's info.
            if let userInfo = self.currentUserRef.childByAppendingPath("User Info") {
                self.userInfoRef = userInfo
                self.userInfoRef.setValue(self.currentUser.toAnyObject());
            }
            
            // When the user disconnects remove the value
            self.currentUserRef.onDisconnectRemoveValue()
        }
    }
}