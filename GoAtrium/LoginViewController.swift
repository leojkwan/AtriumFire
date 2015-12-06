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
    let ref = Firebase(url:"https://goatrium.firebaseio.com")
    
    
    
    func logInFB() {
        facebookLogin.logInWithReadPermissions(["email"], fromViewController: self, handler: {
            (facebookResult, facebookError) -> Void in
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)");
                return
            }
            if facebookResult.isCancelled {
                print("Facebook login was cancelled.");
                return
            }
            
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
        })
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // If user exists, segue into home vc.
        ref.observeAuthEventWithBlock { (authData) -> Void in
            
            if authData != nil {
                self.performSegueWithIdentifier("LoginToList", sender: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func logInFBButtonPressed(sender: AnyObject) {
        logInFB()
    }
    
    
}
