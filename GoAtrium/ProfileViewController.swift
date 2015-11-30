//
//  ProfileViewController.swift
//  GoAtrium
//
//  Created by Leo Kwan on 11/29/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

import UIKit
import Firebase


class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    
    // Initialize emptly array
    var currentUsers: [String] = [String]()
    
    // base url for users
    let usersRef = Firebase(url: "https://goatrium.firebaseio.com/users")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        // ADD NEW USER
        usersRef.observeEventType(.ChildAdded, withBlock: { snapshot in

            // Add the new user to the local array
            self.currentUsers.append(snapshot.value as! String)
            
            // Get the index of the current row
            let row = self.currentUsers.count - 1
            // Create an NSIndexPath for the row
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            // Insert the row for the table with an animation
            self.friendsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
        })
        
        // REMOVE A USER
        // Create a listener for the delta deletions to animate removes from the table view
        usersRef.observeEventType(.ChildRemoved, withBlock: { (snap: FDataSnapshot!) -> Void in
            
            // Get the email to find
            let emailToFind: String! = snap.value as! String
            
            // Loop to find the email in the array
            for(index, email) in self.currentUsers.enumerate() {
                
                // If the email is found, delete it from the table with an animation
                if email == emailToFind {
                    let indexPath = NSIndexPath(forRow: index, inSection: 0)
                    self.currentUsers.removeAtIndex(index)
                    self.friendsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                }
                
            }
            
        })

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        let onlineUserEmail = currentUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    
}
