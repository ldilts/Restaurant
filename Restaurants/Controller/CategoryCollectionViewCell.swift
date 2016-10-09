//
//  CategoryCollectionViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit

class CategoryCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var restaurantsCollectionView: UICollectionView!
    
    var businesses: [Business]! {
        didSet {
            self.restaurantsCollectionView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        restaurantsCollectionView.dataSource = self
        restaurantsCollectionView.delegate = self

        self.restaurantsCollectionView.showsVerticalScrollIndicator = false
        self.restaurantsCollectionView.showsHorizontalScrollIndicator = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.businesses = nil
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let _ = businesses {
            return businesses!.count
        }
        
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "RestaurantCell", for: indexPath) as! RestaurantCollectionViewCell
        
        // Configure the cell
        cell.business = self.businesses[indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NSLog("\nTapped: \(self.businesses[indexPath.row].name!)\n")
    }
    
    // MARK: - Collection view flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 150.0, height: self.frame.height)
    }
    
    // MARK: - Helper methods
}
