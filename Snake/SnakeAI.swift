//  Created by Robert Pankrath on 12.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import Foundation

public protocol SnakeAIType {
    func nextDirection(snake: Snake, target: Point) -> Point
}

class GreedySnakeAI: SnakeAIType {
    
    func nextDirection(snake: Snake, target: Point) -> Point {
        let directions = allDirections(target.indizes.count)
        let head = snake.body.last!
        let validDirections = directions.filter {
            guard let next = try? $0 + head else { return false }
            return snake.validate(next)
        }
        
        let targetDirection = direction(head, to: target)
        let scoredDirections = validDirections.map { ($0, score($0, targetDirection: targetDirection)) }.sort { $0.0.1 > $0.1.1 }
        return scoredDirections.first?.0 ?? directions.first!
    }
    
    private func score(direction: Point, targetDirection: Point) -> Int {
        return direction.indizes.enumerate().reduce(0) {
            $0.0 + 2 - abs($0.1.element - targetDirection.indizes[$0.1.index])
        }
    }
    
    private func direction(from: Point, to: Point) -> Point {
        let indizes = from.indizes.enumerate().map { i, value in
            to.indizes[i]>value ? 1 : to.indizes[i]<value ? -1 : 0
        }
        return Point(indizes: indizes)
    }
    
    private func allDirections(dimension: Int) -> [Point] {
        let directions: [[Point]] = (0..<dimension).flatMap {
            var indizes = [Int](count: dimension, repeatedValue: 0)
            var p = [Point]()
            indizes[$0] = -1
            p.append(Point(indizes: indizes))
            indizes[$0] = 1
            p.append(Point(indizes: indizes))
            return p
        }
        return directions.flatMap {$0}
    }
    
}
