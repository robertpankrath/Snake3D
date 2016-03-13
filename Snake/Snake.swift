//  Created by Robert Pankrath on 11.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import Foundation

public class Snake {
    public var body: [Point]
    public var length: Int    
    public var direction: Point
    
    var alive = true
    public var fieldWidth: Int
    
    public var head: Point {
        return body.last!
    }
    
    init(position: Point, length: Int, fieldWidth: Int) {
        self.fieldWidth = fieldWidth
        self.body = [position]
        self.length = length
        let dimension = position.indizes.count
        var directionIndizes = [Int](count: dimension, repeatedValue: 0)
        directionIndizes[0] = 1
        self.direction = Point(indizes: directionIndizes)
    }
    
    func move() {
        let head = body.last!
        guard let next = try? head + direction else { return }
        if body.count + 1 > length {
            body.removeFirst()
        }
        
        if validate(next) {
            body.append(next)
        } else {
            alive = false
        }        
    }
    
    public func validate(next: Point) -> Bool {
        if body.contains(next) {
            return false
        }
        
        for index in next.indizes {
            if index < 0 || index >= fieldWidth {
                return false
            }
        }
        
        return true
    }
}
