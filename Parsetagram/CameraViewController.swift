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
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        // Get the image captured by the UIImagePickerController
        //let originalImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        let editedImage = info[UIImagePickerControllerEditedImage] as! UIImage
        
        // Do something with the images (based on your use case)
        //Save the image taken or chosen to the view controller
        self.imageTaken = editedImage
        
        // Dismiss UIImagePickerController to go back to your original view controller
        dismiss(animated: true, completion: nil)
        
        //Try to move to next view controller
        self.performSegue(withIdentifier: "configurePost", sender: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        //getPictureFromCamera(true)
    }
    
    @IBAction func takeCameraPhoto(_ sender: AnyObject) {
        getPictureFromCamera(true)
    }
    
    @IBAction func takeLibraryPhoto(_ sender: AnyObject) {
        getPictureFromCameraRoll(true)
    }
    
    func getPictureFromCamera(_ animated: Bool) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.camera
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func getPictureFromCameraRoll(_ animated: Bool) {
        imagePickerController.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Use code below if deciding to segue to new view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let postConfigurationViewController = segue.destination as! PostConfigurationViewController
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
