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
            "title": "Burgers in Toronto",
            "detail": "Hottest Burgers",
            "color": 0xEC4280,
            "location": "Toronto",
            "category": [
                "alias": "hamburger",
                "title": "Hamburgers"
            ]
        ],
        [
            "title": "Pizza in New York",
            "detail": "Top Pizza Places",
            "color": 0x1D62F0,
            "location": "New York",
            "category": [
                "alias": "pizza",
                "title": "Pizza"
            ]
        ]
    ]
}

