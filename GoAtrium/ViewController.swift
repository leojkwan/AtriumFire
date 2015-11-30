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

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // create a reference to the Firebase database
        let myRootRef = Firebase(url:"https://goatrium.firebaseio.com/")
//        let usersRef = myRootRef.childByAppendingPath("users")
//
//        let Leo = ["full_name" : "Leo Kwan"]
//        usersRef.setValue(Leo);
//        
        
        let trainerRef = myRootRef.childByAppendingPath("trainers")
        
        let Leo = ["full_name" : "Trainer Leo"]
        trainerRef.setValue(Leo);

        
        
        let myUsers = Firebase(url: "https://goatrium.firebaseio.com/users")

        
        myUsers.observeEventType(.Value, withBlock: { snapshot in
            print(snapshot.value)
            }, withCancelBlock: { error in
                print(error.description)
        })
        
        
        
    }



}

