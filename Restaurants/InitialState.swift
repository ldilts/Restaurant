//
//  InitialState.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation

// This class is mocking a custom service to provide initial categories
class InitialState {
    static let categories: [String] = [
        "Ethiopian",
        "Japanese",
        "Coffee"]
    
    static let featuredCategories: [FeaturedCategory] = [
        FeaturedCategory(withTitle: "Top Picks in Toronto",
                         andDetail: "Best Pizza Places",
                         andCategory: Category(withAlias: "pizza", andTitle: "pizza")),
        FeaturedCategory(withTitle: "Top Picks in New York",
                         andDetail: "Hottest Burgers",
                         andCategory: Category(withAlias: "hamburger", andTitle: "hamburger"))]
}

