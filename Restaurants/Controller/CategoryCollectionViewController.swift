//
//  CategoryCollectionViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import Alamofire
import CoreLocation

private let reuseIdentifier = "CategoryCell"

class CategoryCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, CLLocationManagerDelegate {
    
    var sections: [Section] = [Section](repeating: Section(),
                                        count:InitialState.categories.count)
    
    private let locationManager = CLLocationManager()
    private let refreshControl: UIRefreshControl = UIRefreshControl()
    
    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        // self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)

        let nib: UINib = UINib(nibName: "FeaturedCategoryCollectionViewCell", bundle: nil)
        self.collectionView?.register(nib, forCellWithReuseIdentifier: "FeaturedCategoryCell")
        
        // Do any additional setup after loading the view.
        self.collectionView?.alwaysBounceVertical = true // Needed for refresh control
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
            self.locationManager.startUpdatingLocation()
        }
        
        self.refreshControl.addTarget(self, action: #selector(CategoryCollectionViewController.refresh(_:)), for: .valueChanged)
        self.collectionView?.addSubview(refreshControl)
        
        self.refresh(sender: self)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.sections.count + 1 // Featured + sections
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        switch kind {
        case UICollectionElementKindSectionHeader:
            let headerView = collectionView
                .dequeueReusableSupplementaryView(ofKind: kind,
                                                  withReuseIdentifier: "CategorySectionHeaderView",
                                                  for: indexPath) as! CategoryHeaderCollectionReusableView
            
            headerView.titleLabel.text = indexPath.section == 0 ? "" : sections[indexPath.section - 1].title
            
            return headerView
        default: assert(false, "Unexpected element kind")
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedCategoryCell", for: indexPath) as! FeaturedCategoryCollectionViewCell
            
            // Configure the cell
//            cell.businesses = sections[indexPath.section].businesses
            
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CategoryCollectionViewCell
        
        // Configure the cell
        cell.businesses = sections[indexPath.section - 1].businesses
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: - Collection view flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        if section == 0 {
            return .zero
        }
        
        return CGSize(width: self.view.frame.width, height: 48.5)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if indexPath.section == 0 {
            
            // Sorry for the magic numbers
            let smallFeaturedImageWidth = (UIScreen.main.bounds.size.width - 80.0) / 5.0
            let featuredRowHeight = ((smallFeaturedImageWidth * 2.0) + 4.0) + 4.0 + smallFeaturedImageWidth + 24.0 + 52.0
            
            return CGSize(width: view.frame.width, height: featuredRowHeight)
        }
        
        let imageHeight = (UIScreen.main.bounds.width - 50.0) / 2.0 // (screen width - padding) / 2.0
        let rowHeight = imageHeight + 8.0 + 68.0 // image height + top padding + bottom padding
        
        return CGSize(width: view.frame.width, height: rowHeight)
    }
    
    // MARK: - Location manager delegate
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // TODO: update with new location!
        
        self.locationManager.stopUpdatingLocation()
    }
    
    // MARK: - Actions
    
    func refresh(_ sender: Any) {
        self.refreshControl.beginRefreshing()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.startUpdatingLocation()
        }
        
        self.sections = [Section](repeating: Section(),
        count:InitialState.categories.count)
        
        for (index, category) in InitialState.categories.enumerated() {
            
            var parameters: Parameters = [
                "term": category]
            
            if CLLocationManager.locationServicesEnabled() {
                if let location = self.locationManager.location {
                    parameters["latitude"] = location.coordinate.latitude
                    parameters["longitute"] = location.coordinate.longitude
                    
                    print("\n Lat: \(location.coordinate.latitude)\n")
                    print("\n Lon: \(location.coordinate.longitude)\n")
                } else {
                    parameters["location"] = "Toronto"
                }
                
                // If this is the last query, stop updating user location
                if index == InitialState.categories.count - 1 {
                    self.locationManager.stopUpdatingLocation()
                }
            } else {
                parameters["location"] = "Toronto"
            }
            
            RequestFactory.request(forType: .Search)?.fetchResults(usingParameters: parameters, andID: nil, andCompletion: { (result) in
                
                if (result != nil) {
                    if let businesses = result as? [Business] {
                        let section = Section(withPosition: index,
                                              andTitle: category,
                                              andBusinesses: businesses)
                        
                        self.sections[index] = section
                        self.collectionView?.reloadData()
                    }
                }
                
                if index == InitialState.categories.count - 1 {
                    self.refreshControl.endRefreshing()
                }
            })
        }
    }
    
    @IBAction func searchButtonTapped(_ sender: UIBarButtonItem) {
        let notificationName = Notification.Name("JumpToSearchNotification")
        
        NotificationCenter.default.post(name: notificationName, object: nil)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     }
     */

}
