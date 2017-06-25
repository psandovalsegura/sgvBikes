//
//  PostConfigurationViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/21/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import CoreLocation
import SafariServices

class PostConfigurationViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var imageTaken: UIImage!
    var coordinates: CLLocationCoordinate2D!
    var safariVC: SFSafariViewController?
    var surveyPresented = false
    
    //Constants for use in resizing image
    let IMAGE_VIEW_WIDTH = 335
    let IMAGE_VIEW_HEIGHT = 261
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = imageTaken
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // Present bike survey for rack
        if !surveyPresented {
            self.safariVC = SFSafariViewController(url: SurveyAid.surveyUrl as! URL)
            self.present(self.safariVC!, animated: true, completion: {
                self.surveyPresented = true
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpload(_ sender: AnyObject) {
        //Start progress HUD, ends in viewDidDisappear()
        MBProgressHUD.showAdded(to: self.view, animated: true)
        
        //Resize image in preparation for upload
        let resizedImage = resize(self.imageTaken, newSize: CGSize(width: IMAGE_VIEW_WIDTH, height: IMAGE_VIEW_HEIGHT))
        Post.postUserImage(resizedImage, withCaption: captionField.text, latitude: String(coordinates.latitude), longitude: String(coordinates.longitude)) { (success, error) in
            ///End progress HUD
            MBProgressHUD.hide(for: self.view, animated: true)
        }
        
        //Increment count
        UserInstance.CURRENT_USER.incrementKey("postsCount")
        
        //Save
        UserInstance.CURRENT_USER.saveInBackground { (success, error) in
            UserInstance.loadUserProperties()
        }
        
        print("By: PostConfigurationViewController.swift \n --------> Upload by \(UserInstance.USERNAME)")
        self.performSegue(withIdentifier: "uploadToHomeSegue", sender: nil)
    }
    
    @IBAction func onCancel(_ sender: AnyObject) {
        self.performSegue(withIdentifier: "cancelToHomeSegue", sender: nil)
    }

    @IBAction func onTap(_ sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func resize(_ image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        resizeImageView.contentMode = UIViewContentMode.scaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.render(in: UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage!
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
        //End progress HUD, which began in onUpload()
        MBProgressHUD.hide(for: self.view, animated: true)
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
