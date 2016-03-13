//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import XCTest
@testable import Snake

class PointTests: XCTestCase {
    
    func testInitWithArray() {
        let indizes = [1, 2, 3, 4, 5]
        let point = Point(indizes: indizes)
        XCTAssertEqual(indizes, point.indizes)
    }
    
    func testInitWithInts() {
        let indizes = [1, 2, 3, 4, 5]
        let point = Point(indizes: 1, 2, 3, 4, 5)
        XCTAssertEqual(indizes, point.indizes)
    }
    
    func testEqual() {
        let point1 = Point(indizes: 1, 2, 3, 4, 5)
        let point2 = Point(indizes: 1, 2, 3, 4, 5)
        XCTAssertTrue(point1 == point2)
        
        let point3 = Point(indizes: 5, 4, 3, 2, 1)
        XCTAssertFalse(point1 == point3)
    }
    
    func testAdd() {
        let point1 = Point(indizes: 1, 2, 3)
        let point2 = Point(indizes: 4, 5, 6)
        let point3 = try! point1 + point2
        XCTAssertEqual([5, 7, 9], point3.indizes)
    }
    
    func testAddThrows() {
        let point1 = Point(indizes: 1, 2, 3)
        let point2 = Point(indizes: 4, 5)
        
        do {
            try point1 + point2
            XCTFail()
        } catch {
            XCTAssertTrue(true)
        }

    }
    
}
