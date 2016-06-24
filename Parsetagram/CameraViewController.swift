//
//  CameraViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit

class CameraViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    let imagePickerController = UIImagePickerController()
    var imageTaken: UIImage = UIImage()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        getPictureFromCamera(true) //The first time the user selects the camera, they will be prompted with the ability to take a photo
    }
    
    func imagePickerController(picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        //Save the image taken or chosen to the view controller
        self.imageTaken = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismissViewControllerAnimated(true, completion: nil)
        
        //Try to move to next view controller
        self.performSegueWithIdentifier("configurePost", sender: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        //getPictureFromCamera(true)
    }
    
    @IBAction func takeCameraPhoto(sender: AnyObject) {
        getPictureFromCamera(true)
    }
    
    @IBAction func takeLibraryPhoto(sender: AnyObject) {
        getPictureFromCameraRoll(true)
    }
    
    func getPictureFromCamera(animated: Bool) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    func getPictureFromCameraRoll(animated: Bool) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        self.presentViewController(imagePickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Use code below if deciding to segue to new view controller
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let postConfigurationViewController = segue.destinationViewController as! PostConfigurationViewController
        postConfigurationViewController.imageTaken = self.imageTaken
        
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
