//
//  MeViewController.swift
//  Parsetagram
//
//  Created by Pedro Sandoval Segura on 6/20/16.
//  Copyright © 2016 Pedro Sandoval Segura. All rights reserved.
//

import UIKit
import Parse
import MBProgressHUD
import GoogleMaps

class MeViewController: UIViewController, CLLocationManagerDelegate {

    
    var myPosts = [PFObject]()
    var mostRecentLocation: CLLocationCoordinate2D!
        
    
    @IBOutlet weak var mapView: GMSMapView!
    var locationManager: CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        myPosts = UserInstance.HOME_VIEW_POSTS
        
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager = CLLocationManager()
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            setupMapView()

        }
        
        
        
    }
    
    func setupMapView(){
        
        mapView.isMyLocationEnabled = true
        
        for post in myPosts{
            
            let lat = post["latitude"] as! String
            let latitude = Double(lat)
            let long = post["longitude"] as! String
            let longitude = Double(long)
            
            let marker = GMSMarker(position: CLLocationCoordinate2DMake(latitude!, longitude!))
            marker.map = mapView
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let locValue: CLLocationCoordinate2D = manager.location!.coordinate
        self.mostRecentLocation = locValue
//        print(locValue)
        let camera = GMSCameraPosition.camera(withLatitude: (locValue.latitude), longitude: (locValue.longitude), zoom: 11.0)
        
        mapView.animate(to: camera)

//        print("locations = \(locValue.latitude) \(locValue.longitude)")
        
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    
    // Method will be called each time when a user change his location access preference.
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            print("User allowed us to access location")
            //do whatever init activities here.
        }
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toSettings", let settingsVC = segue.destinationViewController as? SettingsViewController {
            
        }
    }*/
    

}
