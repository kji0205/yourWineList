//
//  wineListTests.swift
//  wineListTests
//
//  Created by jimmy kim on 2018. 3. 4..
//  Copyright © 2018년 yunaz. All rights reserved.
//

import XCTest
@testable import wineList

class FoodTrackerTests: XCTestCase {
    
    //MARK: Meal Class Tests
    
    // Confirm that the Meal initializer returns a Meal object when passed valid parameters.
    func testMealInitializationSucceeds() {
        
        // Zero rating
        let zeroRatingMeal = Wine.init(name: "Zero", photo: nil, rating: 0)
        XCTAssertNotNil(zeroRatingMeal)
        
        // Positive rating
        let positiveRatingMeal = Wine.init(name: "Positive", photo: nil, rating: 5)
        XCTAssertNotNil(positiveRatingMeal)
        
    }
    
    // Confirm that the Meal initialier returns nil when passed a negative rating or an empty name.
    func testMealInitializationFails() {
        
        // Negative rating
        let negativeRatingMeal = Wine.init(name: "Negative", photo: nil, rating: -1)
        XCTAssertNil(negativeRatingMeal)
        
        // Rating exceeds maximum
        let largeRatingMeal = Wine.init(name: "Large", photo: nil, rating: 6)
        XCTAssertNil(largeRatingMeal)
        
        // Empty String
        let emptyStringMeal = Wine.init(name: "", photo: nil, rating: 0)
        XCTAssertNil(emptyStringMeal)
        
    }
}


