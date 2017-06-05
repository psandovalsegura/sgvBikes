//
//  Post.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/21/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import Foundation
import Parse

class Post: NSObject {
    /**
     * Other methods
     */
    
    /**
     Method to add a user post to Parse (uploading image file)
     
     - parameter image: Image that the user wants upload to parse
     - parameter caption: Caption text input by the user
     - parameter completion: Block to be executed after save operation is complete
     */
    class func postUserImage(_ image: UIImage?, withCaption caption: String?, latitude: String, longitude: String, withCompletion completion: PFBooleanResultBlock?) {
        // Create Parse object PFObject
        let post = PFObject(className: "Post")
        
        // Add relevant fields to the object
        post["media"] = getPFFileFromImage(image) // PFFile column type
        post["author"] = PFUser.current()// Pointer column type that points to PFUser
        post["caption"] = caption
        post["likesCount"] = 0
        post["commentsCount"] = 0
        post["latitude"] = latitude
        post["longitude"] = longitude
        
        //Add username
        let usernameString = (post["author"] as AnyObject).username!!
        post["username"] = usernameString
        
        //Add a date and time of creation in processable format
        post["formattedDateString"] = TimeAid.getFormattedDate()
        
        //Add the profile picture of the user that uploaded the image
        post["associatedProfilePicture"] = getPFFileFromImage(UserInstance.PROFILE_PICTURE)
        
        //Add array to represent users who have liked  -- UPGRADE
        //post["likesBy"]
        
        //Add a comments array
        /* Comments will be stored in a two dimensional array of strings
         * Inner arrays will contain indexes as follows:
         *
         * 0 - username string
         * 1 - timestamp string
         * 2 - comment
         */
        let comments = [[String]]()
        post["comments"] = comments
        
        //Store the commenter profile pictures
        let commenterProfilePictures = [PFFile]()
        post["commenterProfilePictures"] = commenterProfilePictures
        
        // Save object (following function will save the object in Parse asynchronously)
        post.saveInBackground(block: completion)
    }
    
    /**
     Method to convert UIImage to PFFile
     
     - parameter image: Image that the user wants to upload to parse
     
     - returns: PFFile for the the data in the image
     */
    class func getPFFileFromImage(_ image: UIImage?) -> PFFile? {
        // check if image is not nil
        if let image = image {
            // get image data and check if that is not nil
            if let imageData = UIImagePNGRepresentation(image) {
                return PFFile(name: "image.png", data: imageData)
            }
        }
        return nil
    }
}
