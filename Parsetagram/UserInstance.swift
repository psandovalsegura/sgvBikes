//
//  UserInstance.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/22/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation
import Parse
import UIKit

open class UserInstance {
    open static var SUCCESSFUL_ID = false //Testing purposes
    
    open static var CURRENT_USER: PFUser!
    open static var USERNAME: String!
    open static var POSTS_COUNT: Int!
    open static var FOLLWER_COUNT: Int!
    open static var JOIN_DATE: String!
    open static var PROFILE_PICTURE: UIImage!
    open static var PROFILE_PICTURE_PFFILE: PFFile!
    
    //Constants for use in resizing profile image
    open static let PROFILE_VIEW_WIDTH = 40
    open static let PROFILE_VIEW_HEIGHT = 40
    
    open static var POSTS: [PFObject]!
    
    open static var HOME_VIEW_POSTS = [PFObject]()
    
    /* Modification of PFUser object to add more key-value pairs - an implementation of ParseUser.swift
     * Used during sign-up
     *
     * @param user: a PFUser object
     *
     */
    
    static func createUser(_ newUser: PFUser) {
        // Add relevant fields to the object
        newUser["author"] = PFUser.current() // Pointer column type that points to PFUser
        newUser["postsCount"] = 0
        newUser["followerCount"] = 0
        
        //Add a key to keep track of all the post objects
        newUser["allPosts"] = [PFObject]()
        
        //Add username
        let usernameString = (newUser["author"] as AnyObject).username!!
        newUser["username"] = usernameString
        
        //Add user join Date and Time
        newUser["formattedDateString"] = TimeAid.getFormattedDate()
        
        //Add default profile picture as PFFile?
        newUser["profilePicture"] = loadDefaultProfileImageFile()
        
        //Save the object (following function will save the object to Parse asynchronously)
        newUser.saveInBackground { (success, error) in
            if success {
                //The modified PFUser has been saved
                CURRENT_USER = newUser
                loadUserProperties()
            } else {
                //There was a problem, check error.description
            }
        }
    }
    
    
    /* Modification of PFUser object to add more key-value pairs - an implementation of ParseUser.swift
     * Used during log-in, or when user is already logged in
     *
     *
     * @param user: a PFUser object
     *
     */
    
    static func loadUser(_ user: PFUser) {
        CURRENT_USER = user
        loadUserProperties()
    }
    
    
    /* Put all properties specific to the user in constants for easy access
     * Used in sign-up, log-in, and when user is already logged in
     *
     */
    static func loadUserProperties() {
        //Prevent loading properties multiple times
        if (SUCCESSFUL_ID) { return }
        
        USERNAME = CURRENT_USER["username"] as! String
        POSTS_COUNT = CURRENT_USER["postsCount"] as! Int
        FOLLWER_COUNT = CURRENT_USER["followerCount"] as! Int
        JOIN_DATE = CURRENT_USER["formattedDateString"] as! String
        
        //Get a UIImage from a PFFile? object
        let imagePFFile = CURRENT_USER["profilePicture"] as! PFFile
        PROFILE_PICTURE_PFFILE = imagePFFile
        imagePFFile.getDataInBackground(block: {
            (imageData, error) -> Void in
            if error == nil {
                if let imageData = imageData {
                    PROFILE_PICTURE = UIImage(data:imageData)
                    print("By: UserInstance.swift \n --------> Everything loaded properly!")
                }
            }
        }) //End getDataInBackgroundWithBlock()
        
        POSTS = CURRENT_USER["allPosts"] as! [PFObject]
        
    }
    
    /* Load a default profile image from Assets.xcassets
     * Used in sign-up
     *
     */
    static func loadDefaultProfileImageFile() -> PFFile? {
        let defaultImage = UIImage(named: "menewpng")
        let file = Post.getPFFileFromImage(defaultImage)
        return file
    }
    
    
    /* ---------------------------PFUser object modification methods are below-------------------------------- */
    
    static func addPost() {
        //add to array, increment count, save, call loadUserProperties, consider using fetch()
        
    }
    
    static func addFollower() {
        //make structure?, increment, save, call loadUserProperties
        
    }
    
    static func updateProfilePicture(_ newProfileImage: UIImage) {
        
        //Resize image in preparation for upload
        let resizedImage = resize(newProfileImage, newSize: CGSize(width: PROFILE_VIEW_WIDTH, height: PROFILE_VIEW_HEIGHT))
        
        //Update the profile picture
        UserInstance.CURRENT_USER["profilePicture"] = Post.getPFFileFromImage(resizedImage)
        
        //Save
        UserInstance.CURRENT_USER.saveInBackground { (success, error) in
            UserInstance.loadUserProperties()
        }
    }
    
    
    /*-----------------------------Helper functions----------------------------*/
   
    static func resize(_ image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    /*
    /* Attain the rounded profile picture of the username */
    func getProfilePicture(username: String) {
        let query = PFQuery(className: "_User")
        query.whereKey("username", equalTo: username)
        query.findObjectsInBackgroundWithBlock { (objects: [PFObject]?, error: NSError?) in
            if error == nil {
                
                if let objects = objects {
                    let currentCommenterProfile = objects[0]
                    self.currentCommenterPF = currentCommenterProfile["profilePicture"] as! PFFile
                }
                
            }
        }
    }*/
    
    
}







