//  Created by Robert Pankrath on 13.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import XCTest
@testable import Snake

class GameTests: XCTestCase {
    var game: Game!
    
    override func setUp() {
        super.setUp()
        game = Game(dimension: 2, fieldSize: 10, snakeAI: MockAI())
        
    }
    
    func testInit() {
        XCTAssertEqual(game.dimension, 2)
        XCTAssertEqual(game.fieldSize, 10)
        XCTAssertEqual(game.snake.body.last!.indizes, [5, 5])
        XCTAssertNotNil(game.target)
        XCTAssertTrue(game.running)
        XCTAssertEqual(game.snakeTiles, game.snake.body)
        XCTAssertEqual(game.targetPosition, game.target)
    }
    
    func testUpdateCallsAI() {
        XCTAssertEqual(game.snake.direction, Point(indizes: 1, 0))
        game.update()
        XCTAssertEqual(game.snake.direction, Point(indizes: 0, 1))
    }
    
    func testUpdateMovesSnake() {
        XCTAssertEqual(game.snakeTiles.count, 1)
        game.update()
        XCTAssertEqual(game.snakeTiles.count, 2)
    }
    
    func testUpdateDoesNothingIfSnakeIsDead() {
        game.snake.alive = false
        XCTAssertEqual(game.snakeTiles.count, 1)
        game.update()
        XCTAssertEqual(game.snakeTiles.count, 1)
    }

    func testUpdateChecksForCollectingTargets() {
        game.target = Point(indizes: 5, 6)
        game.update()
        XCTAssertNotEqual(game.target, Point(indizes: 5, 6))
    }
}

class MockAI: SnakeAIType {
    func nextDirection(snake: Snake, target: Point) -> Point {
        return Point(indizes: 0, 1)
    }
}
