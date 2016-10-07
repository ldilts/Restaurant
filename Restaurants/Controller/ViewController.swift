//
//  ViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-06.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        loadInitialData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadInitialData() {
        if (!YelpAPIManager.sharedInstance.hasOAuthToken()) {
            YelpAPIManager.sharedInstance.startOAuth2Login(withCompletionHandler: { (success) in
                if success {
                    print("\nSuccess\n")
                } else {
                    print("\nError\n")
                }
            })
        } else {
            // Token found
            print("Token found")
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
