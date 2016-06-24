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

class PostConfigurationViewController: UIViewController {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var captionField: UITextField!
    
    var imageTaken: UIImage!
    
    //Constants for use in resizing image
    let IMAGE_VIEW_WIDTH = 335
    let IMAGE_VIEW_HEIGHT = 261
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = imageTaken
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onUpload(sender: AnyObject) {
        //Start progress HUD, ends in viewDidDisappear()
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        //Resize image in preparation for upload
        let resizedImage = resize(self.imageTaken, newSize: CGSize(width: IMAGE_VIEW_WIDTH, height: IMAGE_VIEW_HEIGHT))
        Post.postUserImage(resizedImage, withCaption: captionField.text) { (success: Bool, error: NSError?) in
            ///End progress HUD
            MBProgressHUD.hideHUDForView(self.view, animated: true)
        }
        
        //Increment count
        UserInstance.CURRENT_USER.incrementKey("postsCount")
        
        //Save
        UserInstance.CURRENT_USER.saveInBackgroundWithBlock { (success: Bool, error: NSError?) in
            UserInstance.loadUserProperties()
        }
        
        print("By: PostConfigurationViewController.swift \n --------> Upload by \(UserInstance.USERNAME)")
        self.performSegueWithIdentifier("uploadToHomeSegue", sender: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelToHomeSegue", sender: nil)
    }

    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func resize(image: UIImage, newSize: CGSize) -> UIImage {
        let resizeImageView = UIImageView(frame: CGRectMake(0, 0, newSize.width, newSize.height))
        resizeImageView.contentMode = UIViewContentMode.ScaleAspectFill
        resizeImageView.image = image
        
        UIGraphicsBeginImageContext(resizeImageView.frame.size)
        resizeImageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(true)
        
        //End progress HUD, which began in onUpload()
        MBProgressHUD.hideHUDForView(self.view, animated: true)
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
