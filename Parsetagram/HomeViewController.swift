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

class HomeViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var refreshControl = UIRefreshControl()
    var isMoreDataLoading = false
    var loadingMoreView:InfiniteScrollActivityView?
    var posts = [PFObject]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Set-up the table view
        tableView.dataSource = self
        tableView.delegate = self
        
        // Set up Infinite Scroll loading indicator
        let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.hidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        // Do any additional setup after loading the view.
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
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.dragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRectMake(0, tableView.contentSize.height, tableView.bounds.size.width, InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Load more results ...
                loadPostData("scrollViewDidScroll")
            }
            
        }
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
                
                // Update flag
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                if let objects = objects {
                    self.posts = objects
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
        // The getObjectInBackgroundWithId methods are asynchronous, so any code after this will run
        // immediately.  Any code that depends on the query result should be moved
        // inside the completion block above.
    
    //Post Cell Deselection -  not handled by table view
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if let path = tableView.indexPathForSelectedRow {
            
            tableView.deselectRowAtIndexPath(path, animated: true)
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toFullDetailView", let detailVC = segue.destinationViewController as? PostDetailViewController, postIndex = tableView.indexPathForSelectedRow?.row {
            detailVC.post = self.posts[postIndex]
        }
    }
 

}
