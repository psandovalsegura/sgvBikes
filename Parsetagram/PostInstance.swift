//
//  PostInstance.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/23/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//
/*
import Foundation
import Parse

class PostInstance {
    
    static func getAttributedProfileImage(post: PFObject) -> UIImage? {
        //Get the profile picture
        if let postImage = post["associatedProfilePicture"] {
            
            let postImagePFFile = postImage as! PFFile
            
            postImagePFFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        return image
                    }
                }
            })
            
        }
    }
    
    
}*/