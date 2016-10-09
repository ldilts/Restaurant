//
//  RestaurantDetailViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController {
    
    var business: Business!
    var reviews: [Review] = [Review]()

    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let business = self.business {
            self.nameLabel.text = business.name ?? ""
            
            RequestFactory.request(forType: .Reviews)?
                .fetchResults(usingParameters: nil,
                         andID: business.id!,
                         andCompletion: { (result) in
                            
                        if (result != nil) {
                            if let reviews = result as? [Review] {
                                self.reviews = reviews
                            }
                        }
                })
        }
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
