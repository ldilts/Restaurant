//
//  ViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-06.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load initial query
        let parameters: Parameters = [
            "term": "ethiopian",
            "latitude": 51.5032520,
            "longitude": -0.1278990]
        
        RequestFactory.request(forType: .Search)?.perform(withParameters: parameters, andCompletion: { (success) in
            if success {
                print("\nSuccess\n")
            } else {
                print("\nOops\n")
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
