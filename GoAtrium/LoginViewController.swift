//
//  LoginViewController.swift
//  GoAtrium
//
//  Created by Leo Kwan on 11/29/15.
//  Copyright © 2015 Leo Kwan. All rights reserved.
//

import UIKit
import Firebase
import FBSDKLoginKit

class LoginViewController: UIViewController {
    
    let facebookLogin = FBSDKLoginManager()
    let ref = Firebase(url:"https://goatrium.firebaseio.com/")

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    
    func logInFB() {
        
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else if facebookResult.isCancelled {
                print("Facebook login was cancelled.")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                self.ref.authWithOAuthProvider("facebook", token: accessToken,
                    withCompletionBlock: { error, authData in
                        if error != nil {
                            print("Login failed. \(error)")
                        } else {
                            print("Logged in! \(authData)")
                            self.performSegueWithIdentifier("LoginToList", sender: nil)
                        }
                })
            }
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // check if user is authenticated. If So. Segue In
        ref.observeAuthEventWithBlock { (authData) -> Void in
            if authData != nil {
                self.performSegueWithIdentifier("LoginToList", sender: nil)
            }
        }

    }
    
    @IBAction func logInFBButtonPressed(sender: AnyObject) {
        logInFB()
    }
    
    
}
