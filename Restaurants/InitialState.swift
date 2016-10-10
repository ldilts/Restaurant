//
//  InitialState.swift
//  Restaurants
//
//  Created by Lucas Dilts on 2016-10-09.
//  Copyright © 2016 Lucas Dilts. All rights reserved.
//

import Foundation

// This class is mocking a custom service to provide initial data
class InitialState {
    
    // Simulating an array of JSON objects
    static let sections: [[String: Any]] = [
        [
            "title": "Ethiopian",
            "category": [
                "alias": "ethiopian",
                "title": "Ethiopian"
            ]
        ],
        [
            "title": "Japanese",
            "category": [
                "alias": "japanese",
                "title": "Japanese"
            ]
        ],
        [
            "title": "Coffee",
            "category": [
                "alias": "coffee",
                "title": "Coffee"
            ]
        ]
    ]
    
    // Simulating an array of JSON objects
    static let featuredSections: [[String: Any]] = [
        [
            "title": "Best of Toronto",
            "detail": "Top Pizza Places",
            "color": 0xEC4280,
            "location": "Toronto",
            "category": [
                "alias": "pizza",
                "title": "Pizza"
            ]
        ],
        [
            "title": "Burgers in New York",
            "detail": "Hottest Burgers",
            "color": 0x1D62F0,
            "location": "New York",
            "category": [
                "alias": "hamburger",
                "title": "Hamburgers"
            ]
        ]
    ]
}

