//
//  User.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/22/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation
import Parse

class ParseUser: NSObject {
    /**
     Method to add a User to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func createUser(withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let currentUser = PFObject(className: "ParseUser")
        
        // Add relevant fields to the object
        currentUser["author"] = PFUser.currentUser() // Pointer column type that points to PFUser
        currentUser["postsCount"] = 0
        currentUser["followerCount"] = 0
        
        //Add a key to keep track of all the post objects
        currentUser["allPosts"] = [PFObject]()
        
        //Add username
        let usernameString = currentUser["author"].username!!
        currentUser["username"] = usernameString
        
        //Add user join Date and Time
        currentUser["formattedDateString"] = TimeAid.getFormattedDate()
        
        //Add default profile picture as PFFile?
        currentUser["profilePicture"] = UserInstance.loadDefaultProfileImageFile()
        
        // Save object (following function will save the object in Parse asynchronously)
        currentUser.saveInBackgroundWithBlock(completion)
    }
    
    /* Function to increment the posts the user has created */
    func incrementPostCount() {
        
    }
    
    /* Function to increase the follower count of a user object */
    func incrementFollowerCount() {
        
    }
    
    /* Function to add a follower to the current user */
    func addFollower() {
        
    }
    
    
}