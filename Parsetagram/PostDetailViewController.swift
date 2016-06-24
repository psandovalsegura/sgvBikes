//
//  PostDetailViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse

class PostDetailViewController: UIViewController {
    
    var post: PFObject!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up all of the outlets
        if let postImage = post["media"] {
            
            let postImagePFFile = postImage as! PFFile
            //If the image could be attained, then likely the comments, likes, caption, etc. as well
            postImagePFFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data: imageData)
                        self.imageView.image = image
                    }
                }
            })
            //Get the author
            usernameLabel.text = "@ \((post["username"] as? String)!)"
            
            //Get date taken
            dateTakenLabel.text = TimeAid.getReadableDateFromFormat(post["formattedDateString"] as! String)
            
            //Get days ago
            daysAgoLabel.text = "\(TimeAid.getTimeDifference(post["formattedDateString"] as! String)) ago"
            
            //Get the likes count
            likesLabel.text = "\(post["likesCount"]) Likes"
            
            //Get the caption
            captionLabel.text = post["caption"] as? String
            
        } else {
            usernameLabel.text = "Error..."
        }

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
