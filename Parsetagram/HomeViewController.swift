//
//  HomeViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set-up the table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Do any additional setup after loading the view.
        //Initially load data
        self.loadPostData("initial")
        
        refreshControl.addTarget(self, action: #selector(loadPostData(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl.backgroundColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.blackColor()
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.whiteColor()])
        tableView.insertSubview(refreshControl, atIndex: 0)
        loadPostData("normal")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("postCell", forIndexPath: indexPath) as! PostTableViewCell
        
        let post = self.posts[indexPath.row]
        
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
        let query = PFQuery(className: "Post")
        query.orderByDescending("createdAt")
        
        if (String(point) == "initial") {
            // Display HUD right before the request is made
            //print("initial request to load")
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        }
        
        query.findObjectsInBackgroundWithBlock { (objects:[PFObject]?, error: NSError?) in
            if error == nil {
                
                //print("successfully retreived")
                if let objects = objects {
                    self.posts = objects
                    self.tableView.reloadData()
                }
                } else {
                    //print("there was an error")
                }
        }
        
        if (String(point) == "initial") {
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        //Stop refesh control
        self.refreshControl.endRefreshing()
        
        //print(self.posts.count)
    }
        // The getObjectInBackgroundWithId methods are asynchronous, so any code after this will run
        // immediately.  Any code that depends on the query result should be moved
        // inside the completion block above.
    
    
    /* Credit for this function to Scott Gardner on Stack Overflow: http://stackoverflow.com/questions/24070450/how-to-get-the-current-time-and-hour-as-datetime */
    func getTimestamp() -> String{
        let timestamp = NSDateFormatter.localizedStringFromDate(NSDate(), dateStyle: .MediumStyle, timeStyle: .ShortStyle)
        return timestamp
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
