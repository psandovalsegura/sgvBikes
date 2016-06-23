//
//  PostTableViewCell.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    @IBOutlet weak var usernameLabel: UILabel! // "author"
    @IBOutlet weak var postImageView: UIImageView! //"media"
    @IBOutlet weak var likesLabel: UILabel! // "likesCount"
    @IBOutlet weak var commentsCountLabel: UILabel! //"commentsCount"
    @IBOutlet weak var captionLabel: UILabel! // "caption"
    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var clockImageView: UIImageView!
    @IBOutlet weak var daysAgoLabel: UILabel!
    
    
    @IBOutlet weak var firstCommentsLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    var liked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create circular profile picture views
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds = true
        profilePictureView.layer.borderColor = UIColor.blackColor().CGColor
        
        //Set up the clock picture
        clockImageView.image = UIImage(named: "daysagopng")
    }

    @IBAction func onLike(sender: AnyObject) {
        //Only allow user to like once -- UPGRADE to be able to unlike!
        if !liked {
            let post = UserInstance.HOME_VIEW_POSTS[sender.tag]
            //Update the post object
            post.incrementKey("likesCount")
            post.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
                self.likesLabel.text = "\(post["likesCount"]) Likes"
                self.likesLabel.textColor = UIColor.redColor()
            }
            self.liked = true
        }
    }
    
    @IBAction func onComment(sender: AnyObject) {
        
    }
    
    @IBAction func onShare(sender: AnyObject) {
        
    }
    
    @IBAction func onImageClick(sender: AnyObject) {
        
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
