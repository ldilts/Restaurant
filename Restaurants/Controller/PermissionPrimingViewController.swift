//
//  PermissionPrimingViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionPrimingViewController: UIViewController, CLLocationManagerDelegate {
    
    var manager: CLLocationManager!
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        manager = CLLocationManager()
        manager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined: break
        case .authorizedWhenInUse: manager.startUpdatingLocation()
        case .authorizedAlways: break
        case .restricted: NSLog("Location services are restricted")
        case .denied: NSLog("Location services were denied")
        }
        
        if status != .notDetermined {
            UserDefaults.standard.set(true, forKey: "OnboardComplete")
            self.performSegue(withIdentifier: "ShowHomeSegue", sender: self)
        }
    }
    
    // MARK: - Actions
    
    @IBAction func doneButtonTapped(_ sender: UIButton) {
        // Try to get user permission for location
        if CLLocationManager.authorizationStatus() == .notDetermined {
            manager.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
