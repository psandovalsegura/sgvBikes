//
//  MeViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class MeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var postCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var myPosts = [PFObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set up the table view
        tableView.dataSource = self
        tableView.delegate = self
        
        //Initially load data
        self.loadPostData("initial")
        
        refreshControl.addTarget(self, action: #selector(loadPostData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()])
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadPostData("viewDidLoad")
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPosts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        
        let post = self.myPosts[indexPath.row]
        
        //Populate the custom table cell
        if let postImage = post["media"] {
            
            let postImagePFFile = postImage as! PFFile
            //If the image could be attained, then likely the comments, likes, caption, etc. as well
            postImagePFFile.getDataInBackgroundWithBlock({
                (imageData: NSData?, error: NSError?) -> Void in
                if error == nil {
                    if let imageData = imageData {
                        let image = UIImage(data:imageData)
                        cell.postImageView.image = image
                    }
                }
            })
            
            //Get the caption
            cell.captionLabel.text = post["caption"] as? String
            
            //Get the likes count
            cell.likesLabel.text = "\(post["likesCount"]) Likes"
            
            //Get the comments count
            cell.commentsLabel.text = "\(post["commentsCount"]) Comments"
            
            //Get the author
            cell.usernameLabel.text = post["username"] as? String
            
        }
        
        return cell
    }
    
    func loadPostData(point: AnyObject) {
        //ProgressHUD initialized
        if (String(point) == "initial") {
            // Display HUD right before the request is made
            print("initial request to load")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) in
            if error == nil {
                
                //print("successfully retreived")
                
                if let objects = objects {
                    self.myPosts = objects
                    self.tableView.reloadData()
                }
                
            } else {
                //print("there was an error")
            }
        }
        
        //Stop refesh control
        self.refreshControl.endRefreshing()
        
        /*for number in 0 ..< 1000000 { //Slow the app
         print(number)
         }*/
        
        if (String(point) == "initial") {
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            print("end initial request to load")
        }
    }

    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        // Set the username label
        usernameLabel.text = "@ \(PFUser.currentUser()!.username!)"
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSettings", let settingsVC = segue.destinationViewController as? SettingsViewController {
            
        }
    }
    

}
