//
//  FeaturedRestaurantsTableViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class FeaturedRestaurantsTableViewController: UITableViewController {
    
    var businesses: [Business]! {
        didSet {
            self.tableView.reloadData()
        }
    }
    
    private var selectedBusiness: Business?
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register cell
        let nib: UINib = UINib(nibName: "RestaurantTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "RestaurantTableViewCell")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let uBusinesses = self.businesses {
            return uBusinesses.count
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantTableViewCell",
                                                 for: indexPath) as! RestaurantTableViewCell
        if let uBusinesses = self.businesses {
            cell.business = uBusinesses[indexPath.row]
        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 84.0
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedBusiness = self.businesses[indexPath.row]
        self.performSegue(withIdentifier: "RestaurantDetailSegue", sender: self)
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            if identifier == "RestaurantDetailSegue" {
                if let uSelectedBusiness = self.selectedBusiness {
                    let destinationViewController = segue.destination
                        as! RestaurantDetailViewController
                    
                    destinationViewController.business = uSelectedBusiness
                }
            }
        }
    }

}
