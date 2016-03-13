//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import XCTest
@testable import Snake

class SnakeTests: XCTestCase {
    var snake: Snake!
    
    override func setUp() {
        super.setUp()
        snake = Snake(position: Point(indizes: 1, 1), length: 5, fieldWidth: 10)
    }

    func testInit() {
        XCTAssertEqual(snake.fieldWidth, 10)
        XCTAssertEqual(snake.length, 5)
        XCTAssertEqual(snake.body.count, 1)
        XCTAssertEqual(snake.head.indizes, [1, 1])
        XCTAssertEqual(snake.direction.indizes, [1, 0])
    }
    
    func testValidateCorrect() {
        XCTAssertTrue(snake.validate(Point(indizes: 1, 2)))
    }
    
    func testValidateBodyHit() {
        XCTAssertFalse(snake.validate(Point(indizes: 1, 1)))
    }
    
    func testValidateOutOfBounds() {
        XCTAssertFalse(snake.validate(Point(indizes: 1, -1)))
        XCTAssertFalse(snake.validate(Point(indizes: 13, 2)))
    }
    
    func testMove() {
        snake.body = [Point(indizes: 1, 1), Point(indizes: 1, 2), Point(indizes: 1, 3), Point(indizes: 1, 4), Point(indizes: 1, 5)]
        snake.direction = Point(indizes: 0, 1)
        snake.move()
        XCTAssertTrue(snake.alive)
        XCTAssertEqual(snake.body.count, snake.length)
        XCTAssertEqual(snake.body.last, Point(indizes: 1, 6))
        XCTAssertEqual(snake.body.first,
            Point(indizes: 1, 2))
    }
    
    func testMoveDie() {
        snake.fieldWidth = 6
        snake.body = [Point(indizes: 1, 1), Point(indizes: 1, 2), Point(indizes: 1, 3), Point(indizes: 1, 4), Point(indizes: 1, 5)]
        snake.direction = Point(indizes: 0, 1)
        snake.move()
        XCTAssertFalse(snake.alive)
    }
}
