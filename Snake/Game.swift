//  Created by Robert Pankrath on 11.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import Foundation

public class Game: NSObject {

    var snake: Snake
    var target: Point!
    let dimension: Int
    let fieldSize: Int

    let snakeAI: SnakeAIType
    
    public var running: Bool {
        return snake.alive
    }
    
    public var snakeTiles: [Point] {
        return snake.body
    }
    
    public var targetPosition: Point {
        return target
    }
    
    public init(dimension: Int, fieldSize: Int, snakeAI: SnakeAIType) {
        self.dimension = dimension
        self.fieldSize = fieldSize
        self.snakeAI = snakeAI
        let midPointIndizes = [Int](count: dimension, repeatedValue: fieldSize/2)
        snake = Snake(position: Point(indizes: midPointIndizes), length: 5, fieldWidth: fieldSize)
        super.init()
        target = targetPoint()
    }
    
    public convenience init(dimension: Int, fieldSize: Int) {
        self.init(dimension: dimension, fieldSize: fieldSize, snakeAI: GreedySnakeAI())
    }
    
    public func update() {
        guard snake.alive else { return }
        
        snake.direction = snakeAI.nextDirection(snake, target: target)
        
        snake.move()
        if snake.body.last == target {
            target = targetPoint()
            snake.length++
        }
    }
    
    private func targetPoint() -> Point {
        var p: Point
        repeat {
            p = randomPoint()
        } while snake.body.contains(p)
        return p
    }
    
    private func randomPoint() -> Point {
        let indizes: [Int] = (0..<dimension).map { _ in random()%fieldSize }
        return Point(indizes: indizes)
    }
    
}
