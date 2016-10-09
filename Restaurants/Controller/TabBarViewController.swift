//
//  TabBarViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let notificationName = Notification.Name("JumpToSearchNotification")
        
        NotificationCenter.default.addObserver(self, selector: #selector(TabBarViewController.jumpToSearch), name: notificationName, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Helper Methods
    
    func jumpToSearch() {
        
        if let viewControllers = self.viewControllers {
            if viewControllers.count > 1 {
                if let searchViewController = viewControllers[1] as? RestaurantsTableViewController {
                    searchViewController.shouldStartSearch = true
                }
            }
        }
    
        self.selectedIndex = 1
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
