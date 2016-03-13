//  Created by Robert Pankrath on 11.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import Foundation

enum PointError: ErrorType {
    case DimensionMissmatch
}

public func == (lhs: Point, rhs: Point) -> Bool {
    return lhs.indizes == rhs.indizes
}

public func + (lhs: Point, rhs: Point) throws -> Point {
    guard lhs.indizes.count == rhs.indizes.count else { throw PointError.DimensionMissmatch }
    return Point(indizes: lhs.indizes.enumerate().map { $0.element + rhs.indizes[$0.index] })
}

public struct Point {
    public let indizes: [Int]
    
    public init(indizes: [Int]) {
        self.indizes = indizes
    }
    
    public init(indizes: Int...) {
        self.indizes = indizes
    }
}

extension Point: Equatable {}
