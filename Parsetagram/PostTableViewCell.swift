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
    
    /* These outlets are specific for use in the Home View Feed */
    @IBOutlet weak var latestCommentsLabel: UILabel!
    @IBOutlet weak var latestCommenterUsername: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var commentButton: UIButton!
    @IBOutlet weak var imageButton: UIButton!
    
    @IBOutlet weak var smallerUsernameLabel: UILabel!
    
    @IBOutlet weak var favoritesImageView: UIImageView!
    @IBOutlet weak var commentsImageView: UIImageView!
    
    
    var liked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Create circular profile picture views
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
        profilePictureView.clipsToBounds = true
        
        //TODO: Set up the clock picture
        
    }

    @IBAction func onLike(_ sender: AnyObject) {
        //Only allow user to like once -- UPGRADE to be able to unlike!
        if !liked {
            let post = UserInstance.HOME_VIEW_POSTS[sender.tag]
            //Update the post object
            post.incrementKey("likesCount")
            post.saveInBackground { (success, error) in
                self.likesLabel.text = "\(post["likesCount"]!) Likes"
            }
            
            self.liked = true
        }
    }
    
    @IBAction func onComment(_ sender: AnyObject) {
        print("By: PostTableViewCell.swift \n --------> comments clicked")
    }
    
    @IBAction func onImageClick(_ sender: AnyObject) {
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
