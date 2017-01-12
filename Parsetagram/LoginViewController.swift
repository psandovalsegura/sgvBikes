//
//  LoginViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onSignIn(_ sender: AnyObject) {
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!, block: {(user, error) in
            if user != nil {
                print("By: LoginViewController.swift \n --------> Login success.")
                UserInstance.loadUser(user!)
                //Manually segue
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                //Animate an alert for ERROR
                if let errorString = error.debugDescription as? String {
                    self.errorAlert(errorString)
                } else {
                    self.errorAlert("Something went wrong...")
                }
                
            }
        })
        /*
        PFUser.logInWithUsername(inBackground: usernameField.text!, password: passwordField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("By: LoginViewController.swift \n --------> Login success.")
                UserInstance.loadUser(user!)
                //Manually segue
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
            } else {
                //Animate an alert for ERROR
                if let errorString = error!.userInfo["error"] as? String {
                    self.errorAlert(errorString)
                } else {
                    self.errorAlert("Something went wrong...")
                }
                
            }
        }*/
        
    }
    
    @IBAction func onSignUp(_ sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameField.text
        newUser.password = passwordField.text
        newUser.signUpInBackground { (success, error) in
            if success {
                print("By: LoginViewController.swift \n --------> Created a user!")
                //Manually segue
                self.performSegue(withIdentifier: "loginSegue", sender: nil)
                UserInstance.createUser(newUser)
            } else {
                //Animate an alert for ERROR
                if let errorString = error.debugDescription as? String {
                    self.errorAlert(errorString)
                } else {
                    self.errorAlert("Something went wrong...")
                }
                
                /*
                 print(error?.localizedDescription)
                 print("Error code: \(error?.code)")
                 if error?.code == 202 {                     //Modify this snippet to produce better alerts
                 print("Username is taken")
                 }*/
            }

        }
    }
    
    @IBAction func onTap(_ sender: AnyObject) {
        view.endEditing(true)
    }

    func errorAlert(_ errorString: String) {
        let alertController = UIAlertController(title:"Error",  message: errorString, preferredStyle: .alert)
        let okAction = UIAlertAction(title:"OK", style: .cancel) { (action) in
            //code is run when user chooses cancel
        }
        alertController.addAction(okAction)
        self.present(alertController, animated: true) {
            //optional code that is run after the alert has finished presenting
        }
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
