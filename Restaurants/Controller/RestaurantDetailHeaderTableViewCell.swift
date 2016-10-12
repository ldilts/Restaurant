//
//  RestaurantDetailHeaderTableViewCell.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-11.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import UIKit
import AlamofireImage

class RestaurantDetailHeaderTableViewCell: UITableViewCell, UIScrollViewDelegate {

//    @IBOutlet weak var previewImageView: UIImageView!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var business: Business! {
        didSet {
            self.configureUI()
        }
    }
    
    // MARK: - Life cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.scrollView.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.business = nil
        
        for subView in self.scrollView.subviews {
            subView.removeFromSuperview()
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    // MARK: - Scroll view delegate
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageNumber = round(scrollView.contentOffset.x / scrollView.frame.size.width)
        pageControl.currentPage = Int(pageNumber)
    }
    
    // MARK: - Helper Methods
    
    private func configureUI() {
        self.configurePageControl()
        
        if let uBusiness = self.business {
        
            for index in 0..<uBusiness.photos.count {
                
                frame.origin.x = self.scrollView.frame.size.width * CGFloat(index)
                frame.size = self.scrollView.frame.size
                self.scrollView.isPagingEnabled = true
                
                let subView = UIImageView(frame: frame)
                subView.contentMode = .scaleAspectFill
                subView.backgroundColor = UIColor.lightGray
                
                if let url = URL(string: uBusiness.photos[index]) {
                    subView.af_setImage(withURL: url,
                                        imageTransition: .crossDissolve(0.2))
                }
                
                self.scrollView.addSubview(subView)
            }
            
            self.scrollView.contentSize = CGSize(width: (self.scrollView.frame.size.width * CGFloat(uBusiness.photos.count)),
                                                 height: self.scrollView.frame.size.height)
            self.pageControl.addTarget(self, action: #selector(RestaurantDetailHeaderTableViewCell.changePage(_:)), for: .valueChanged)

        }
    }
    
    private func configurePageControl() {
        
        if let uBusiness = self.business {
            self.pageControl.numberOfPages = uBusiness.photos.count
            self.pageControl.currentPage = 0
        }
    }
    
    @objc private func changePage(_ sender: Any)  {
        let x = CGFloat(pageControl.currentPage) * scrollView.frame.size.width
        scrollView.setContentOffset(CGPoint(x: x, y: 0), animated: true)
    }

}
