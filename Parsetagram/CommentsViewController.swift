//
//  CommentsViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/23/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class CommentsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var post: PFObject!
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var profilePictureView: UIImageView!
    
    @IBOutlet weak var commentTextField: UITextField!
    @IBOutlet weak var tableView: UITableView!
    
    var usernames: [String]!
    var timestamps: [String]!
    var comments: [String]!
    var commenterPFFiles: [PFFile]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        
        // Create circular profile picture view
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds = true
        
        loadControllerData()
        
        // Do any additional setup after loading the view.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("commentCell", forIndexPath: indexPath) as! CommentTableViewCell
        //Fill labels
        cell.usernameLabel.text = self.usernames[indexPath.row]
        cell.commentLabel.text = self.comments[indexPath.row]
        cell.timeAgoLabel.text = TimeAid.getTimeDifferencePhrase(self.timestamps[indexPath.row])
        
        //Set profile pictures
        let file = self.commenterPFFiles[indexPath.row]
        file.getDataInBackgroundWithBlock({
            (imageData: NSData?, error: NSError?) -> Void in
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage(data:imageData)
                    cell.commenterProfileView.image = image
                }
            }
        })
        
        //print("By: CommentsViewController.swift \n --------> index path.row = \(indexPath.row) and the comment is = \(self.comments[indexPath.row])")
        //Allow for profile picture in comments -- UPGRADE
        return cell
    }
    
    
    @IBAction func onSend(sender: AnyObject) {
        //Start progress HUD
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        if self.commentTextField.text != nil && self.commentTextField != "" {
            //Update the users, comments, timestamps before packing
            self.usernames.append(UserInstance.USERNAME)
            self.timestamps.append(TimeAid.getFormattedDate())
            self.comments.append(self.commentTextField.text!)
            
            //Put the commenter profile image (as PFFile) in the commenter profile pictures storage of the Post object
            var commenterProfilePFFiles = self.post["commenterProfilePictures"] as! [PFFile]
            commenterProfilePFFiles.append(UserInstance.PROFILE_PICTURE_PFFILE)
            self.post["commenterProfilePictures"] = commenterProfilePFFiles
            
            //Clear the text field and stop editing
            self.commentTextField.text = ""
            self.view.endEditing(true)
            
            //Send to Parse Servers
            let updatedStorage = CommentAid.repackCommentArray(self.usernames, timestamps: self.timestamps, comments: self.comments)
            self.post["comments"] = updatedStorage
            self.post.incrementKey("commentsCount")
            self.post.saveInBackgroundWithBlock({ (success: Bool, error: NSError?) in
                self.loadControllerData()
                self.tableView.reloadData()
                MBProgressHUD.hideHUDForView(self.view, animated: true)
            })
            
        }
    }
    
    func loadControllerData() {
        //Get profile picture of post and other attributes
        if let postImage = post["associatedProfilePicture"] {
            
            let postImagePFFile = postImage as! PFFile
            
            postImagePFFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        self.profilePictureView.image = image
                    }
                }
            })
            
            //Get commenter PFFiles to recreate images
            self.commenterPFFiles = post["commenterProfilePictures"] as! [PFFile]
            
            //Get the caption
            self.captionLabel.text = post["caption"] as? String
            
            //Get the author
            self.usernameLabel.text = post["username"] as? String
            
            //Get first comment if one exists
            let storage = post["comments"] as! [[String]]
            if !storage.isEmpty {
                let restructuredStorage = CommentAid.unpackCommentArray(storage)
                self.usernames = restructuredStorage.usernames
                self.timestamps = restructuredStorage.timestamps
                self.comments = restructuredStorage.comments
            } else {
                // No comments on this post
                self.comments = [String]()
                self.usernames = [String]()
                self.timestamps = [String]()
            }
            
            
        }
        
        if let user = post["username"] {
            let usernameString = user as! String
            //Get the author
            usernameLabel.text = "@ \(usernameString)"
        } else {
            usernameLabel.text = "Error..."
        }
        
        
    }
    
    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
