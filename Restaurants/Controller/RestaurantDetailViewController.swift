//
//  RestaurantDetailViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-07.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

/*
 0. Business Images
 1. Title + Rating + Categories
 2. Address + Location
 3. Phone
 4. Website
 5. Reviews
 */

typealias Tag = Int

enum RestaurantDetailCellType: Tag {
    case header = 1
    case title = 2
    case address = 3
    case phone = 4
    case website = 5
}

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var cellTypesForDisplay: [RestaurantDetailCellType] = [RestaurantDetailCellType]()
    
    var business: Business!
    var reviews: [Review] = [Review]()
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let business = self.business {
            
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
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if self.reviews.count > 0 {
            return 2
        }
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? self.calculateNumberOfRows() : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let uBusiness = self.business {
            if indexPath.section == 0 {
                // Business information row
                
                let cellType: RestaurantDetailCellType = self.cellTypesForDisplay[indexPath.row]
                
                switch cellType {
                case .header:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailHeaderCell",
                                                             for: indexPath) as! RestaurantDetailHeaderTableViewCell
                    cell.business = uBusiness
                    return cell
                    
                case .title:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "RestaurantDetailTitleCell",
                                                             for: indexPath) as! RestaurantDetailTitleTableViewCell
                    cell.business = uBusiness
                    return cell
                    
                case .address, .phone, .website:
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "",
                                                             for: indexPath) as! RestaurantDetailActionTableViewCell
                    cell.business = uBusiness
                    cell.actionType = cellType
                    return cell
                    
                }
                
            } else {
                // Review row
            }
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "restaurantCell", for: indexPath)
        
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            let cellType: RestaurantDetailCellType = self.cellTypesForDisplay[indexPath.row]
            
            switch cellType {
            case .header: return (UIScreen.main.bounds.width * 9) / 16.0 // 16:9 ratio
            case .title: return 68.0
            case .address, .phone, .website: return 60.0
            }
        }
        
        return 44.0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // TODO: implement
    }
    
    // MARK: - Helper Methods
    
    private func calculateNumberOfRows() -> Int {
        var numberOfRows: Int = 0
        self.cellTypesForDisplay.removeAll(keepingCapacity: false)
        
        if let uBusiness = self.business {
            if let _ = uBusiness.imageURL {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.header)
            }
            
            if let _ = uBusiness.name {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.title)
            }
            
            if let location = uBusiness.location {
                if let _ = location.address1 {
                    numberOfRows += 1
                    self.cellTypesForDisplay.append(.address)
                }
            }
            
            if let _ = uBusiness.phone {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.phone)
            }
            
            if let _ = uBusiness.url {
                numberOfRows += 1
                self.cellTypesForDisplay.append(.website)
            }
        }
        
        return numberOfRows
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
