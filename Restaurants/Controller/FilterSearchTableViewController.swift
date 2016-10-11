//
//  FilterSearchTableViewController.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

protocol FilterDelegate: class {
    func updateSortByFilter(_ sortBy: String)
    func updatePriceFilter(_ price: String)
    func updateOpenNowFilter(_ openNow: Bool)
}

class FilterSearchTableViewController: UITableViewController {
    
    weak var delegate: FilterDelegate?
    
    @IBOutlet weak var sortBySegmentedControl: UISegmentedControl!
    @IBOutlet weak var priceSegmentedControl: UISegmentedControl!
    @IBOutlet weak var openNowSwitch: UISwitch!
    
    // Query Filters
    var sortBy: String = "best_match"
    var price: String = "1,2,3,4"
    var openNow: Bool = false

    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        switch sortBy {
        case "rating":
            sortBySegmentedControl.selectedSegmentIndex = 1
        case "review_count":
            sortBySegmentedControl.selectedSegmentIndex = 2
        default:
            sortBySegmentedControl.selectedSegmentIndex = 0
        }
        
        switch price {
        case "1":
            priceSegmentedControl.selectedSegmentIndex = 1
        case "2":
            priceSegmentedControl.selectedSegmentIndex = 2
        case "3":
            priceSegmentedControl.selectedSegmentIndex = 3
        case "4":
            priceSegmentedControl.selectedSegmentIndex = 4
        default:
            priceSegmentedControl.selectedSegmentIndex = 0
        }
        
        openNowSwitch.isOn = openNow
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view delegate

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    
    // MARK: - Actions
    
    @IBAction func sortByFilterChanged(_ sender: UISegmentedControl) {
        let option: String!
        
        switch sender.selectedSegmentIndex {
        case 1: option = "rating"
        case 2: option = "review_count"
        default: option = "best_match"
        }
        
        self.updateSortByFilter(option)
    }
    
    @IBAction func priceFilterChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            self.updatePriceFilter("1,2,3,4")
            return
        }
        
        self.updatePriceFilter("\(sender.selectedSegmentIndex)")
    }
    
    @IBAction func openNowFilterChanged(_ sender: UISwitch) {
        self.updateOpenNowFilter(sender.isOn)
    }
    
    // MARK: - Filter Delegate
    
    private func updateSortByFilter(_ sortBy: String) {
        self.delegate?.updateSortByFilter(sortBy)
    }
    
    private func updatePriceFilter(_ price: String) {
        self.delegate?.updatePriceFilter(price)
    }

    private func updateOpenNowFilter(_ openNow: Bool) {
        self.delegate?.updateOpenNowFilter(openNow)
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
