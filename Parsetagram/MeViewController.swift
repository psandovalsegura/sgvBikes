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
    @IBOutlet weak var joinDateLabel: UILabel!
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
        self.loadPostData("initial" as AnyObject)
        
        refreshControl.addTarget(self, action: #selector(loadPostData(_:)), for: UIControlEvents.valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.black])
        tableView.insertSubview(refreshControl, at: 0)
        loadPostData("viewDidLoad" as AnyObject)
        /*
        print(UserInstance.USERNAME)
        print(UserInstance.FOLLWER_COUNT)
        print(UserInstance.JOIN_DATE)
        print(UserInstance.POSTS_COUNT)*/
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.myPosts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        let post = self.myPosts[indexPath.row]
        
        //Populate the custom table cell
        if let postImage = post["media"] {
            
            let postImagePFFile = postImage as! PFFile
            //If the image could be attained, then likely the comments, likes, caption, etc. as well
            postImagePFFile.getDataInBackground(block: {
                (imageData, error) in
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
            cell.commentsCountLabel.text = "\(post["commentsCount"])"
            
            //Get the author
            cell.usernameLabel.text = post["username"] as? String
            
            //Get the profile picture
            if let profileImage = post["associatedProfilePicture"] {
                
                let postImagePFFile = profileImage as! PFFile
                
                postImagePFFile.getDataInBackground(block: {
                    (imageData, error) in
                    if error == nil {
                        if let imageData = imageData {
                            let image = UIImage(data:imageData)
                            cell.profilePictureView.image = image
                        }
                    }
                })
                
            }
            
            //Get amount of days ago
            cell.daysAgoLabel.text = TimeAid.getFeedTimeDifference((post["formattedDateString"] as! String))
            
        }
        
        return cell
    }
    
    func loadPostData(_ point: AnyObject) {
        //ProgressHUD initialized
        if (String(describing: point) == "initial") {
            // Display HUD right before the request is made
            print("By: MeViewController.swift \n --------> initial request to load")
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.whereKey("username", equalTo: PFUser.current()!.username!)
        //query.whereKey("_p_author", equalTo: <#T##AnyObject#>) //try this query for safety in better release
        
        query.findObjectsInBackground { (objects, error) in
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
        
        if (String(describing: point) == "initial") {
            // Hide HUD once the network request comes back (must be done on main UI thread)
            MBProgressHUD.hide(for: self.view, animated: true)
            print("By: MeViewController.swift \n --------> end initial request to load")
        }
    }

    

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        // Set the username label
        //UserInstance.loadUserProperties()
        usernameLabel.text = "@ \(UserInstance.USERNAME)"
        postCountLabel.text = "\(UserInstance.POSTS_COUNT) Posts"
        joinDateLabel.text = "Joined \(TimeAid.getReadableDateFromFormat(UserInstance.JOIN_DATE))"
        loadPostData("viewWillAppear" as AnyObject)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSettings", let settingsVC = segue.destinationViewController as? SettingsViewController {
            
        }
    }*/
    

}
