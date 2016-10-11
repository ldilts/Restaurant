//
//  RestaurantsTableViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

class RestaurantsTableViewController: UITableViewController, CLLocationManagerDelegate, UISearchBarDelegate, FilterDelegate {
    
    // Search
    var businesses: [Business] = [Business]()
    
    var selectedBusiness: Business?
    
    // Autocomplete
    var autocompleteBusinesses: [Business] = [Business]()
    var autocompleteCategories: [Category] = [Category]()
    
    var selectedAutocompleteBusiness: Business?
    var selectedAutocompleteCategory: Category?
    
    // Query Filters
    private var sortBy: String = "best_match"
    private var price: String = "1,2,3,4"
    private var openNow: Bool = false
    
    // Other
    var resultSearchController = UISearchController()
    var shouldStartSearch: Bool = false
    
    private let locationManager = CLLocationManager()
    private var latestLocation: CLLocation? {
        didSet {
            if let _ = latestLocation {
                // fetch with location
            }
        }
    }
    
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
        self.resultSearchController.searchBar.delegate = self
        
        self.tableView.tableHeaderView = self.resultSearchController.searchBar
        
        // get user location is permitted
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        self.showSearchBar()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText == "" {
            self.restartSearch()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if self.selectedAutocompleteBusiness != nil
                || self.selectedAutocompleteCategory != nil {
                // Businesses
                return 1
            } else {
                // Autocomplete suggestions
                return 2
            }
        }
        
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if self.selectedAutocompleteBusiness != nil
                || self.selectedAutocompleteCategory != nil {
                // Business
                
                return self.businesses.count
            } else {
                // Autocomplete suggestions
                
                if section == 0 {
                    // Business autocomplete suggestions
                    return self.autocompleteBusinesses.count
                } else {
                    // Category autocomplete suggestions
                    return self.autocompleteCategories.count
                }
            }
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if self.selectedAutocompleteBusiness != nil
                || self.selectedAutocompleteCategory != nil {
                // Show business
                let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantSearchResult",
                                                         for: indexPath) as! SearchResultRestaurantTableViewCell
                cell.business = businesses[indexPath.row]
                
                return cell
            } else {
                // Show autocomplete suggestion
                let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
                
                if indexPath.section == 0 {
                    // Show business autocomplete suggestion
                    cell.textLabel?.text = autocompleteBusinesses[indexPath.row].name ?? ""
                } else {
                    // Show category autocomplete suggestion
                    cell.textLabel?.text = autocompleteCategories[indexPath.row].title ?? ""
                }
                
                return cell
                
            }
            
        } else {
            // TODO: Show search history
            let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
            return cell
        }
    }
    
    // MARK: - Table view delegate
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if self.selectedAutocompleteBusiness != nil
                || self.selectedAutocompleteCategory != nil {
                // Business row
                return 84.0
            } else {
                // Autocomplete row
                
                return 44.0
            }
            
        } else {
            // TODO: Search history row
            return 44.0
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.resultSearchController.isActive
            && self.resultSearchController.searchBar.text != "" {
            
            if self.selectedAutocompleteBusiness != nil
                || self.selectedAutocompleteCategory != nil {
                // Business selected
                self.selectedBusiness = self.businesses[indexPath.row]
                self.performSegue(withIdentifier: "businessDetailSegue", sender: self)

            } else {
                // Autocomplete suggestion selected
                
                if indexPath.section == 0 {
                    // Business autocomplete suggestion selected
                    self.selectedAutocompleteBusiness = self.autocompleteBusinesses[indexPath.row]
                    
                    if let query = selectedAutocompleteBusiness!.name {
                        performQuery(withTerm: query)
                    }
                } else {
                    // Category autocomplete suggestion selected
                    self.selectedAutocompleteCategory = self.autocompleteCategories[indexPath.row]
                    
                    if let query = selectedAutocompleteCategory!.alias {
                        performQuery(withTerm: query)
                    }
                }
                
            }
            
        } else {
            // TODO: Search history selected
        }
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.latestLocation = locations[0]
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Filter Delegate
    
    func updateSortByFilter(_ sortBy: String) {
        self.sortBy = sortBy
    }
    
    func updatePriceFilter(_ price: String) {
        self.price = price
    }
    
    func updateOpenNowFilter(_ openNow: Bool) {
        self.openNow = openNow
    }
    
    // MARK: - Actions
    
    @IBAction func filterButtonTapped(_ sender: UIBarButtonItem) {
        self.performSegue(withIdentifier: "filterSearchSegue", sender: self)
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        self.showSearchBar()
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
    
    private func performQuery(withTerm term: String) {
        
        let attribute: String?
        
        switch resultSearchController.searchBar.selectedScopeButtonIndex {
        case 1: attribute = "hot_and_new"
        case 2: attribute = "deals"
        default: attribute = nil
        }
        
        var parameters: Parameters = [
            "term": term,
            "sort_by": sortBy,
            "price": price,
            "open_now": openNow,
            "attributes": attribute]
        
        if CLLocationManager.locationServicesEnabled() && latestLocation != nil {
            parameters["latitude"] = latestLocation!.coordinate.latitude
            parameters["longitude"] = latestLocation!.coordinate.longitude
        } else {
            parameters["location"] = "Toronto"
        }
        
        RequestFactory.request(forType: .Search)?.fetchResults(usingParameters: parameters, andID: nil, andCompletion: { (result) in
            
            if (result != nil) {
                if let businesses = result as? [Business] {
                    self.businesses = businesses
                    self.tableView.reloadData()
                }
            }
        })
    }
    
    private func restartSearch() {
        self.autocompleteBusinesses = [Business]()
        self.autocompleteCategories = [Category]()
        self.businesses = [Business]()
        
        self.selectedAutocompleteBusiness = nil
        self.selectedAutocompleteCategory = nil
        self.selectedBusiness = nil
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let identifier = segue.identifier {
            
            switch identifier {
            case "businessDetailSegue":
                if let destinationViewController = segue.destination
                    as? RestaurantDetailViewController {
                    
                    if let business = self.selectedBusiness {
                        destinationViewController.business = business
                    }
                    
                    self.selectedBusiness = nil
                }
                
                break
                
            case "filterSearchSegue":
                if let destinationViewController = segue.destination
                    as? FilterSearchTableViewController {
                    
                    self.restartSearch()
                    
                    destinationViewController.sortBy = self.sortBy
                    destinationViewController.price = self.price
                    destinationViewController.openNow = self.openNow
                    destinationViewController.delegate = self
                }
            break
            default: break
            }
            
        }
        
        
    }

}

// MARK: - Search results updating

extension RestaurantsTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        self.autocompleteBusinesses.removeAll(keepingCapacity: false)
        self.autocompleteCategories.removeAll(keepingCapacity: false)
        
        let parameters: Parameters = [
            "text": resultSearchController.searchBar.text!,
            "latitude": 51.5032520,
            "longitude": -0.1278990]
        
        RequestFactory.request(forType: .Autocomplete)?
            .fetchResults(usingParameters: parameters,
                          andID: nil,
                          andCompletion: { (result) in
                            
            if (result != nil) {
                if let results = result as? AutocompleteResult {
                    self.autocompleteBusinesses = results.businesses
                    self.autocompleteCategories = results.categories
                    
                    self.tableView.reloadData()
                }
            }
                            
        })
    }
    
    
}
