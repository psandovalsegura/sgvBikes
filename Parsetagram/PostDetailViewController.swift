//
//  PostDetailViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import GoogleMaps

class PostDetailViewController: UIViewController {
    
    var post: PFObject!

    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var dateTakenLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var daysAgoLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var captionLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up all of the outlets
        if let postImage = post["media"] {
            
//            let postImagePFFile = postImage as! PFFile
            // If the image could be attained, then likely the comments, likes, caption, etc. as well
//            postImagePFFile.getDataInBackground(block: { (imageData, error) in
//                if error == nil {
//                    if let imageData = imageData {
//                        let image = UIImage(data: imageData)
//                        self.imageView.image = image
//                    }
//                }
//            })
            setupMapView()
            
            // Get the author
            usernameLabel.text = "@ \((post["username"] as? String)!)"
            
            // Get date taken
            dateTakenLabel.text = TimeAid.getReadableDateFromFormat(post["formattedDateString"] as! String)
            
            // Get days ago
            daysAgoLabel.text = TimeAid.getTimeDifferencePhrase(post["formattedDateString"] as! String)
            
            // Get the likes count
            let likesCount = post["likesCount"] as! Int
            if likesCount == 1 {
                likesLabel.text = "1 Like"
            } else {
                likesLabel.text = "\(likesCount) Likes"
            }
            
            
            // Get the caption
            captionLabel.text = post["caption"] as? String
            
            // Get the coordinates of the image
            let latitudeString = post["latitude"] as? String
            let longitudeString = post["longitude"] as? String
            let latitudeDouble = Double(latitudeString!)!.truncate(places: 4)
            let longitudeDouble = Double(longitudeString!)!.truncate(places: 4)
            
            latitudeLabel.text = String(describing: latitudeDouble)
            longitudeLabel.text = String(describing: longitudeDouble)
            
        } else {
            usernameLabel.text = "Error..."
        }
        
        
        // Do any additional setup after loading the view.
    }
    
    func setupMapView(){
        
        let lat = post["latitude"] as? String

        let latitude = Double(lat!)
        let long = post["longitude"] as? String
        let longitude = Double(long!)
        
        let camera = GMSCameraPosition.camera(withLatitude: latitude!, longitude: longitude!, zoom: 16.0)
        mapView.camera = camera
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: latitude!, longitude: longitude!)
        marker.title = "test"
        marker.snippet = "testing"
        marker.map = mapView
        
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
