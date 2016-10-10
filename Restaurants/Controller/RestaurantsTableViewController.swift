//
//  RestaurantsTableViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire

class RestaurantsTableViewController: UITableViewController {
    
    var businesses: [Business] = [Business]()
    var categories: [Category] = [Category]()
    
    
    var selectedBusiness: Business?
    var selectedCategory: Business?
    
    var suggestions: [Business] = [Business]()
    var resultSearchController = UISearchController()
    
    var shouldStartSearch: Bool = false
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Setup search UI
        self.resultSearchController = UISearchController(searchResultsController: nil)
        self.resultSearchController.searchResultsUpdater = self
        self.resultSearchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true // The search bar should only stay in this view
        self.resultSearchController.searchBar.sizeToFit()
        self.resultSearchController.searchBar.scopeButtonTitles = ["All", "Hot & New", "Deals"]
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
//        self.tableView.reloadData()
        
//        self.hideSearchBar()
        
//        self.refreshControl?.addTarget(self, action: #selector(RestaurantsTableViewController.refresh(_:)), for: .valueChanged)
        
//        self.refresh(sender: self)

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            return 2
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if section == 0 {
                return businesses.count
            }
            
            return categories.count
        }
        
        // TODO: Cache search terms
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            if indexPath.section == 0 {
                cell.textLabel?.text = businesses[indexPath.row].name!
            } else {
                cell.textLabel?.text = categories[indexPath.row].title
            }
        }
        
//        else {
//            cell.textLabel?.text = businesses[indexPath.row].name!
//        }

        return cell
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultSearchController.isActive {
            if indexPath.section == 0 {
                self.selectedBusiness = self.businesses[indexPath.row]
                self.performSegue(withIdentifier: "businessDetailSegue", sender: self)
            } else {
                // TODO: Category action
            }
        }
        
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */
    
    
    
    
    // MARK: - Actions
    
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        self.showSearchBar()
    }
    
    func refresh(_ sender: Any) {
        self.refreshControl?.beginRefreshing()
        
//        // Load initial query
//        let parameters: Parameters = [
//            "term": "ethiopian",
//            "latitude": 51.5032520,
//            "longitude": -0.1278990]
//        
//        RequestFactory.request(forType: .Search)?
//            .fetchResults(usingParameters: parameters, andID: nil, andCompletion: { (result) in
//                
//                if (result != nil) {
//                    if let businesses = result as? [Business] {
//                        self.businesses = businesses
//                    }
//                    
//                    self.tableView.reloadData()
//                }
//                
                self.refreshControl?.endRefreshing()
//            })
    }
    
    // MARK: - Helper Methods
    
//    private func hideSearchBar() {
//        var contentOffset: CGPoint  = self.tableView.contentOffset
//        contentOffset.y += self.tableView.tableHeaderView!.frame.height
//        self.tableView.contentOffset = contentOffset
//    }
    
    private func showSearchBar() {
        UIView.animate(withDuration: 0.25, delay: 0.0, options: .curveEaseIn, animations: {
            self.tableView.contentOffset = CGPoint(x: 0.0, y: 0.0 - self.tableView.contentInset.top)
        }) { (success) in
            self.resultSearchController.searchBar.becomeFirstResponder()
            self.shouldStartSearch = false
        }
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let destinationViewController = segue.destination
            as? RestaurantDetailViewController {
            
            if let business = self.selectedBusiness {
                destinationViewController.business = business
            }
            
            self.selectedBusiness = nil
        }
        
//        self.resultSearchController.dismiss(animated: false, completion: nil)
    }

}

// MARK: - Search results updating

extension RestaurantsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.suggestions.removeAll(keepingCapacity: false)
        
        let attribute: String?
        
        switch searchController.searchBar.selectedScopeButtonIndex {
        case 1: attribute = "hot_and_new"
        case 2: attribute = "deals"
        default: attribute = nil
        }
        
        let parameters: Parameters = [
            "text": searchController.searchBar.text!,
            "latitude": 51.5032520,
            "longitude": -0.1278990,
            "attributes": attribute]
        
        RequestFactory.request(forType: .Autocomplete)?
            .fetchResults(usingParameters: parameters,
                          andID: nil,
                          andCompletion: { (result) in
                            
            if (result != nil) {
                if let results = result as? AutocompleteResult {
                    self.businesses = results.businesses
                    self.categories = results.categories
                    
                    self.tableView.reloadData()
                }
            }
                            
        })
    }
    
    
}
