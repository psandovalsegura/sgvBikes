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
    public static var SUCCESSFUL_ID = false //Testing purposes
    
    public static var USERS_LOADED = [PFObject]()
    public static var CURRENT_USER = PFObject(className: "ParseUser")
    public static var USERNAME: String!
    public static var POSTS_COUNT: Int!
    public static var FOLLWER_COUNT: Int!
    
    /* Modification of PFUser object to contain more keys - an implementation of ParseUser.swift
     * 
     */
    
    static func loadUser() {
        let query = PFQuery(className: "ParseUser")
        query.whereKey("username", equalTo: PFUser.currentUser()!.username!)
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) in
            if error == nil {

                if let parseUsers = objects {
                    USERS_LOADED = parseUsers
                }
                
            }
        }
    }
    
    static func loadUserProperties() {
        //Prevent loading properties multiple times
        if (SUCCESSFUL_ID) { return }
        
        if USERS_LOADED.count > 1 {
            print("By: UserInstance.swift \n --------> There are \(USERS_LOADED.count) users with the same username.")
        } else if USERS_LOADED.count == 1 {
            //Only one user with a given username should be present
            CURRENT_USER = USERS_LOADED[0]
        }
        
        //Load all ParseUser properties for easy access -- ParseUser class will still be used to update user data
        //----USERNAME = UserInstance.CURRENT_USER["username"] as! String
        
        
        
        //----print("By: UserInstance.swift \n --------> Attempt to access data... username: \(USERNAME)")
        
        //Flag if loading was success
        if (USERNAME as? String!) != nil {
            SUCCESSFUL_ID = true
        } else {
            print("ERROR HAPPENS SOMETIMES")
        }
        print(SUCCESSFUL_ID)
    }
    
    static func loadDefaultProfileImageFile() -> PFFile? {
        let defaultImage = UIImage(named: "mepng")
        let file = Post.getPFFileFromImage(defaultImage)
        return file
    }
    
}