//
//  FeaturedCategoryCollectionViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-10.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit



class FeaturedCategoryCollectionViewCell: UICollectionViewCell, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var featuredRestaurantsCollectionView: UICollectionView!
    @IBOutlet weak var gradientBackgroundView: UIView!
    
    weak var navigationDelegate: NavigationDelegate?
    
    var featuredSections: [FeaturedSection]! {
        didSet {
            featuredRestaurantsCollectionView.reloadData()
        }
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        featuredRestaurantsCollectionView.dataSource = self
        featuredRestaurantsCollectionView.delegate = self
        
        self.featuredRestaurantsCollectionView.showsVerticalScrollIndicator = false
        self.featuredRestaurantsCollectionView.showsHorizontalScrollIndicator = false
        
        let nib: UINib = UINib(nibName: "FeaturedRestaurantsCollectionViewCell", bundle: nil)
        self.featuredRestaurantsCollectionView.register(nib, forCellWithReuseIdentifier: "FeaturedRestaurantsCell")
        
        // Setup backgroung
        
        let topColour = UIColor(red: (253.0/255.0),
                                green: (253.0/255.0),
                                blue: (254.0/255.0),
                                alpha: 1.0)
        
        let bottomColour = UIColor(red: (240.0/255.0),
                                   green: (240.0/255.0),
                                   blue: (240.0/255.0),
                                   alpha: 1.0)
        
        self.gradientBackgroundView.applyGradient(colours: [topColour, bottomColour])
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
    }
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard let _ = featuredSections else {
            return 0
        }
        
        return featuredSections!.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FeaturedRestaurantsCell", for: indexPath) as! FeaturedRestaurantsCollectionViewCell
        
        // Configure the cell
        cell.featuredSection = self.featuredSections![indexPath.row]
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegate
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedFeaturedSection = self.featuredSections[indexPath.row]
        self.navigationDelegate?.featuredSectionTapped(selectedFeaturedSection)
    }
    
    // MARK: - Collection view flow layout delegate
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let columnWidth = (UIScreen.main.bounds.width - 40.0) // (screen width - padding)
        
        return CGSize(width: columnWidth, height: self.frame.height)
    }
}


