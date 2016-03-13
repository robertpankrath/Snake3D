//  Created by Robert Pankrath on 12.03.16.
//  Copyright © 2016 Robert Pankrath. All rights reserved.

import Cocoa
import Snake

public class GameDrawer: NSObject {
    let fieldSize: Int
    
    let xAxis = CGPoint(x: 1, y: 1)
    let yAxis = CGPoint(x: 0, y: 1)
    let zAxis = CGPoint(x: -1, y: 1)

    let border: CGFloat = 10
    var blockWidth: CGFloat = 7
    
    var hue: CGFloat = 0
    
    let numStars = 200
    var stars = [(CGPoint, CGFloat)]()

    public init(fieldSize: Int) {
        self.fieldSize = fieldSize
        hue = CGFloat(random()%1000)/1000
        super.init()
    }
    
    public func draw(game: Game, bounds: CGRect) {
        guard let ctx = NSGraphicsContext.currentContext()?.CGContext else { return }

        CGContextScaleCTM(ctx, 1, -1)
        CGContextTranslateCTM(ctx, 0, -bounds.height)
      
        drawBackground(ctx, bounds: bounds)
        
        calculateBlockWidth(bounds)
        let offset = borderOffset(bounds)
        
        let targetHue = hue <= 0.5 ? hue + 0.5 : hue - 0.5
        let blocks = game.snakeTiles.enumerate().map { ($0.element, NSColor(calibratedHue: hue, saturation: 1, brightness: 0.3 + CGFloat($0.index)/CGFloat(game.snakeTiles.count), alpha: 1)) } + [(game.targetPosition,         NSColor(calibratedHue: targetHue, saturation: 1, brightness: 1, alpha: 1))]
        
        blocks.sort { distance2Cam($0.0) > distance2Cam($1.0) }.forEach {
            drawBlock($0, color: $1, offset: offset)
        }
        
        hue += 0.0001
        if hue > 1 {
            hue -= 1
        }
    }
    
    private func drawBackground(ctx: CGContext, bounds: CGRect) {
        NSColor(calibratedHue: hue, saturation: 0.7, brightness: 0.1, alpha: 1).setFill()
        CGContextFillRect(ctx, bounds)
        drawStars(ctx, bounds: bounds)
    }
    
    private func drawStars(ctx: CGContext, bounds: CGRect) {
        if stars.isEmpty {
            stars = (0..<numStars).map { _ in
                (CGPoint(x: random()%Int(bounds.width), y: random()%Int(bounds.height)), CGFloat(random()%30000)/1000)
            }
        }
        
        stars.enumerate().forEach { i, star in
            NSColor(calibratedHue: hue, saturation: 0.7, brightness: 1, alpha: (sin(star.1) + 1)/2).setFill()
            CGContextFillRect(ctx, CGRect(origin: star.0, size: CGSize(width: 1, height: 1)))
            stars[i] = (star.0, star.1 + CGFloat(random()%100)/1000)
        }
    }
    
    private func calculateBlockWidth(bounds: CGRect) {
        let cornerPoints = [
            Point(indizes: 0, 0, 0),
            Point(indizes: fieldSize, 0, 0),
            Point(indizes: fieldSize, fieldSize, 0),
            Point(indizes: 0, fieldSize, 0),
            Point(indizes: 0, 0, fieldSize),
            Point(indizes: fieldSize, 0, fieldSize),
            Point(indizes: fieldSize, fieldSize, fieldSize),
            Point(indizes: 0, fieldSize, fieldSize),
        ]
        
        blockWidth = 1
        
        let screenPoints = cornerPoints.map { screenPos($0.indizes[0], y: $0.indizes[1], z: $0.indizes[2], offset: .zero) }
        
        let (minX, maxX, minY, maxY) = screenPoints.reduce((CGFloat(100000), CGFloat(0), CGFloat(1000000), CGFloat(0))) {
            (min($0.0.0, $0.1.x), max($0.0.1, $0.1.x), min($0.0.2, $0.1.y), max($0.0.3, $0.1.y))
        }
        
        blockWidth = min((bounds.width-border*2)/(maxX-minX), (bounds.height-2*border)/(maxY-minY))
    }
    
    private func borderOffset(bounds: CGRect) -> CGPoint {
        return CGPoint(x:bounds.width/2, y:(bounds.height - 3*blockWidth*CGFloat(fieldSize))/2)
    }
    
    private func distance2Cam(point: Point) -> Int {
        return point.indizes[0] - point.indizes[1] + point.indizes[2]
    }
    
    private func drawBlock(point: Point, color: NSColor, offset: CGPoint) {
        let x = point.indizes[0]
        let y = point.indizes[1]
        let z = point.indizes[2]
        
        let p1 = screenPos(x, y: y, z: z, offset: offset)
        let p2 = screenPos(x+1, y: y, z: z, offset: offset)
        let p3 = screenPos(x+1, y: y+1, z: z, offset: offset)
        let p4 = screenPos(x, y: y+1, z: z, offset: offset)
        let p5 = screenPos(x, y: y, z: z+1, offset: offset)
        let p7 = screenPos(x+1, y: y+1, z: z+1, offset: offset)
        let p8 = screenPos(x, y: y+1, z: z+1, offset: offset)
        
        color.colorWithBrightnessFactor(0.5).setStroke()
                
        color.colorWithBrightnessFactor(0.7).setFill()
        drawPolygon([p3, p4, p8, p7])
        color.colorWithBrightnessFactor(0.6).setFill()
        drawPolygon([p1, p5, p8, p4])
        color.setFill()
        drawPolygon([p1, p2, p3, p4])
    }
    
    private func screenPos(x: Int, y: Int, z: Int, offset: CGPoint) -> CGPoint {
        let xx = offset.x + CGFloat(x) * xAxis.x * blockWidth + CGFloat(y) * yAxis.x * blockWidth + CGFloat(z) * zAxis.x * blockWidth
        let yy = offset.y + CGFloat(x) * xAxis.y * blockWidth + CGFloat(y) * yAxis.y * blockWidth + CGFloat(z) * zAxis.y * blockWidth
        return CGPoint(x: xx, y: yy)
    }
    
    private func drawPolygon(points: [CGPoint]) {
        let path = NSBezierPath()
        path.moveToPoint(points.first!)
        points.forEach {
            path.lineToPoint($0)
        }
        path.closePath()
        path.fill()
        path.stroke()
    }
}

extension NSColor {
    func colorWithBrightnessFactor(factor: CGFloat) -> NSColor {
        var h: CGFloat = 0
        var s: CGFloat = 0
        var b: CGFloat = 0
        var a: CGFloat = 0
        self.getHue(&h, saturation: &s, brightness: &b, alpha: &a)
        return NSColor(calibratedHue: h, saturation: s, brightness: b*factor, alpha: a)
    }
}
