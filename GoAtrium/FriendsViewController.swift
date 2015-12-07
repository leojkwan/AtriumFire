import UIKit
import Firebase

class FriendsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var friendsTableView: UITableView!
    var currentUser:Athlete!
    
    // Initialize empty array.
    var onlineUsers: [String] = [String]()
    
    // base url for users
    let userbaseRef = Firebase(url: "https://goatrium.firebaseio.com/userbase")
    var currentUserRef: Firebase!
    var userInfoRef: Firebase!
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.delegate = self
        friendsTableView.dataSource = self
        
        /**
        * SET USER PROPERTY WITH FB AUTH DATA
        */
        
        userbaseRef.observeAuthEventWithBlock { authData in
            
            // Create a child reference with FB user id
            self.currentUser = Athlete(authData: authData)
            
            // Create Firebase URL paths
            if let currentUser = self.userbaseRef.childByAppendingPath(self.currentUser.displayname) {
                self.currentUserRef = currentUser;
            }
            
            if let userInfo = self.currentUserRef.childByAppendingPath("User Info") {
                self.userInfoRef = userInfo
            }
            
            self.currentUserRef.setValue(self.currentUser.email)
            self.userInfoRef.setValue(self.currentUser.toAnyObject());
            // When the user disconnects remove the value
            
            self.currentUserRef.onDisconnectRemoveValue()
            
            /**
            * ADD CONNECETED USER FROM TABLE VIEW
            */
            self.userbaseRef.observeEventType(.ChildAdded, withBlock: {  snap  in
                
                // Add the new user to the local array
                let firstName = snap.key as String
                self.onlineUsers.append(firstName)
                
                // Get the index of the current row
                let row = self.onlineUsers.count - 1
                
                // Create an NSIndexPath for the row
                let indexPath = NSIndexPath(forRow: row, inSection: 0)
                
                // Insert the row for the table with an animation
                self.friendsTableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Top)
                self.friendsTableView.reloadData()
            })
            
            /**
            * REMOVE DISCONNECTED USER FROM TABLE VIEW
            */
            
            // Create a listener for the delta deletions to animate removes from the table view
            self.userbaseRef.observeEventType(.ChildRemoved, withBlock: { (snap: FDataSnapshot!) -> Void in
                // Get the email to find.
                let emailToFind: String! = snap.key as String
                
                // Loop to find the email in the array.
                for(index, email) in self.onlineUsers.enumerate() {
                    let emailAtThisIndex = email
                    // If the email is found, delete it from the table with an animation
                    if emailAtThisIndex == emailToFind {
                        let indexPath = NSIndexPath(forRow: index, inSection: 0)
                        self.onlineUsers.removeAtIndex(index)
                        self.friendsTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                        self.friendsTableView.reloadData()
                    }
                }
            })
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return onlineUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("friendCell", forIndexPath: indexPath)
        let onlineUserEmail = onlineUsers[indexPath.row]
        cell.textLabel?.text = onlineUserEmail
        return cell
    }
    
    
}
