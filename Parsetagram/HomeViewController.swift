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
    
    let QUERY_LIMIT = 5
    
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
        let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
        loadingMoreView = InfiniteScrollActivityView(frame: frame)
        loadingMoreView!.isHidden = true
        tableView.addSubview(loadingMoreView!)
        
        var insets = tableView.contentInset;
        insets.bottom += InfiniteScrollActivityView.defaultHeight;
        tableView.contentInset = insets
        
        //Refresh control setup
        refreshControl.addTarget(self, action: #selector(loadPostData(_:)), for: UIControlEvents.valueChanged)
        refreshControl.backgroundColor = UIColor.clear
        refreshControl.tintColor = UIColor.black
        refreshControl.attributedTitle = NSAttributedString(string: "Last updated on \(TimeAid.getTimestamp())", attributes: [NSForegroundColorAttributeName: UIColor.black])
        tableView.insertSubview(refreshControl, at: 0)
        
        //Initially load data
        self.loadPostData("initial" as AnyObject)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "postCell", for: indexPath) as! PostTableViewCell
        
        cell.imageButton.tag = indexPath.row
        cell.likeButton.tag = indexPath.row
        cell.commentButton.tag = indexPath.row
        
        let post = self.posts[indexPath.row]
        
        //Populate the custom table cell
        //If the image could be attained, then likely the comments, likes, caption, etc. as well
        if let postImage = post["media"] {
            
            let postImagePFFile = postImage as! PFFile
            
            postImagePFFile.getDataInBackground(block: {
                (imageData, error) -> Void in
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
            cell.likesLabel.text = "\(post["likesCount"]!) Likes"
            
            //Get the comments count
            cell.commentsCountLabel.text = "\(post["commentsCount"]!)"
            
            //Get the author
            cell.usernameLabel.text = post["username"] as? String
            
            //Get the other username label
            cell.smallerUsernameLabel.text = cell.usernameLabel.text
            
            //Get the profile picture
            if let profileImage = post["associatedProfilePicture"] {
                
                let postImagePFFile = profileImage as! PFFile
                
                postImagePFFile.getDataInBackground(block: {
                    (imageData, error) -> Void in
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
            
            //Get first comment if one exists
            let storage = post["comments"] as! [[String]]
            if !storage.isEmpty {
                cell.latestCommentsLabel.text = CommentAid.getLatestComment(storage).comment
                cell.latestCommenterUsername.text = CommentAid.getLatestComment(storage).username
            } else {
                cell.latestCommenterUsername.text = ""
                cell.latestCommentsLabel.text = "More..."
            }
            
            
        }
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // Handle scroll behavior here
        if (!isMoreDataLoading) {
            
            // Calculate the position of one screen length before the bottom of the results
            let scrollViewContentHeight = tableView.contentSize.height
            let scrollOffsetThreshold = scrollViewContentHeight - tableView.bounds.size.height
            
            // When the user has scrolled past the threshold, start requesting
            if(scrollView.contentOffset.y > scrollOffsetThreshold && tableView.isDragging) {
                isMoreDataLoading = true
                
                // Update position of loadingMoreView, and start loading indicator
                let frame = CGRect(x: 0, y: tableView.contentSize.height, width: tableView.bounds.size.width, height: InfiniteScrollActivityView.defaultHeight)
                loadingMoreView?.frame = frame
                loadingMoreView!.startAnimating()
                
                //Load more results ...
                loadPostData("scrollViewDidScroll" as AnyObject)
            }
            
        }
    }
    
    func loadPostData(_ point: AnyObject) {
        //ProgressHUD initialized
        if (String(describing: point) == "initial") {
            // Display HUD right before the request is made
            print("By: HomeViewController.swift \n --------> initial request to load")
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }
        
        let query = PFQuery(className: "Post")
        query.order(byDescending: "createdAt")
        query.limit = QUERY_LIMIT
        
        if String(describing: point) == "scrollViewDidScroll" {
            //User reached the bottom of the feed, load NEW posts
            query.skip = QUERY_LIMIT
        }
        
        query.findObjectsInBackground { (objects, error) in
            if error == nil {
                
                //print("successfully retreived")
                
                // Update flag
                self.isMoreDataLoading = false
                // Stop the loading indicator
                self.loadingMoreView!.stopAnimating()
                
                if let objects = objects {
                    if String(describing: point) == "scrollViewDidScroll" {
                        self.posts += objects
                        UserInstance.HOME_VIEW_POSTS += objects
                    } else {
                        self.posts = objects
                        UserInstance.HOME_VIEW_POSTS = objects
                    }
                    self.tableView.reloadData()
                }
                
            } else {
                //print("there was an error")
            }
            
            if (String(describing: point) == "initial") {
                // Hide HUD once the network request comes back (must be done on main UI thread)
                MBProgressHUD.hide(for: self.view, animated: true)
                print("By: HomeViewController.swift \n --------> end initial request to load")
            }
            
            //Stop refesh control
            self.refreshControl.endRefreshing()
        }
        
    }
        // The getObjectInBackgroundWithId methods are asynchronous, so any code after this will run
        // immediately.  Any code that depends on the query result should be moved
        // inside the completion block above.
    
    //Post Cell Deselection -  not handled by table view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let path = tableView.indexPathForSelectedRow {
            
            tableView.deselectRow(at: path, animated: true)
        }
        
        self.loadPostData("viewWillAppear" as AnyObject)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toFullDetailView", let detailVC = segue.destination as? PostDetailViewController {
            detailVC.post = self.posts[((sender as AnyObject).tag)!]
        } else if segue.identifier == "toCommentsView", let commentsVC = segue.destination as? CommentsViewController {
            commentsVC.post = self.posts[((sender as AnyObject).tag)!]
        }
    }
 

}
