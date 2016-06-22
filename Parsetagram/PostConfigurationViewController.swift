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
    
    var imageTaken: UIImage? = nil

    @IBOutlet weak var captionField: UITextField!
    
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
        //Start progress HUD
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        Post.postUserImage(imageTaken, withCaption: captionField.text) { (success: Bool, error: NSError?) in
        
        }
        
        print("Upload by \(PFUser.currentUser()?.username)")
        self.performSegueWithIdentifier("uploadToHomeSegue", sender: nil)
    }
    
    @IBAction func onCancel(sender: AnyObject) {
        self.performSegueWithIdentifier("cancelToHomeSegue", sender: nil)
    }

    @IBAction func onTap(sender: AnyObject) {
        self.view.endEditing(true)
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
