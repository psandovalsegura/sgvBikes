//
//  SettingsViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/22/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD

class SettingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    var newProfilePicture: UIImage = UIImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        
        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func changeProfilePicture(sender: AnyObject) {
        getPictureFromCameraRoll(true)
    }
    
    func getPictureFromCameraRoll(animated: Bool) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func logOut(sender: AnyObject) {
        PFUser.logOutInBackgroundWithBlock { (error: NSError?) in
            // PFUser.currentUser() will now be nil
        }
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        //Save the image taken or chosen to the view controller
        self.newProfilePicture = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        //Save the profile picture to the current user
        UserInstance.updateProfilePicture(self.newProfilePicture)
        
        
    }
    
    
    func alertUserOfProfileImageChange() {
        let alertController = UIAlertController(title:"Success",  message: "Your profile image was changed! Post or comment to try it out.", preferredStyle: .Alert)
        let okAction = UIAlertAction(title:"OK", style: .Cancel) { (action) in
            //code is run when user chooses ok
        }
        alertController.addAction(okAction)
        self.presentViewController(alertController, animated: true) {
            //optional code that is run after the alert has finished presenting
        }
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
