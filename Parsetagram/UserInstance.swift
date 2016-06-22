//
//  UserInstance.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/22/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation
import Parse

public class UserInstance {
    public static var MAGIC_NUMBER = -1 //Testing purposes
    
    public static var USERS_LOADED = [PFObject]()
    public static var CURRENT_USER = PFObject(className: "ParseUser")
    
    
    static func loadUser(){
        let query = PFQuery(className: "ParseUser")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) in
            if error == nil {

                if let object = objects {
                    USERS_LOADED = object
                    if USERS_LOADED.count > 1 {
                        print("By: UserInstance.swift \n --------> There are multiple users with the same username.")
                    } else if USERS_LOADED.count == 1 {
                        //Only one user with a given username should be present
                        //CURRENT_USER =
                        //print("By: UserInstance.swift \n --------> GOOD. There should only be 1 user. Attempt to acces fields: username: \()")
                    }
                    //print("There is \(USERS_LOADED.count) users")
                }
                
            } else {
                //print("there was an error")
            }
        }
        
        
    }
    
    
}