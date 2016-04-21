//: [Previous](@previous)

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCPlayground

let vc = UIViewController()


// Create a CAShapeLayer
let shapeLayer = CAShapeLayer()

// The Bezier path that we made needs to be converted to 
// a CGPath before it can be used on a layer.
shapeLayer.path = createBezierPath().CGPath

// apply other properties related to the path
shapeLayer.strokeColor = UIColor.blueColor().CGColor
shapeLayer.fillColor = UIColor.whiteColor().CGColor
shapeLayer.lineWidth = 1.0
shapeLayer.position = CGPoint(x: 10, y: 10)

// add the new layer to our custom view
vc.view.layer.addSublayer(shapeLayer)

XCPlaygroundPage.currentPage.liveView = vc


func createBezierPath() -> UIBezierPath {
    
    // create a new path
    let path = UIBezierPath()
    
    // starting point for the path (bottom left)
    path.moveToPoint(CGPoint(x: 2, y: 26))
    
    // *********************
    // ***** Left side *****
    // *********************
    
    // segment 1: line
    path.addLineToPoint(CGPoint(x: 2, y: 15))
    
    // segment 2: curve
    path.addCurveToPoint(CGPoint(x: 0, y: 12), // ending point
        controlPoint1: CGPoint(x: 2, y: 14),
        controlPoint2: CGPoint(x: 0, y: 14))
    
    // segment 3: line
    path.addLineToPoint(CGPoint(x: 0, y: 2))
    
    // *********************
    // ****** Top side *****
    // *********************
    
    // segment 4: arc
    path.addArcWithCenter(CGPoint(x: 2, y: 2), // center point of circle
        radius: 2, // this will make it meet our path line
        startAngle: CGFloat(M_PI), // π radians = 180 degrees = straight left
        endAngle: CGFloat(3*M_PI_2), // 3π/2 radians = 270 degrees = straight up
        clockwise: true) // startAngle to endAngle goes in a clockwise direction
    
    // segment 5: line
    path.addLineToPoint(CGPoint(x: 8, y: 0))
    
    // segment 6: arc
    path.addArcWithCenter(CGPoint(x: 8, y: 2),
                          radius: 2,
                          startAngle: CGFloat(3*M_PI_2), // straight up
        endAngle: CGFloat(0), // 0 radians = straight right
        clockwise: true)
    
    // *********************
    // ***** Right side ****
    // *********************
    
    // segment 7: line
    path.addLineToPoint(CGPoint(x: 10, y: 12))
    
    // segment 8: curve
    path.addCurveToPoint(CGPoint(x: 8, y: 15), // ending point
        controlPoint1: CGPoint(x: 10, y: 14),
        controlPoint2: CGPoint(x: 8, y: 14))
    
    // segment 9: line
    path.addLineToPoint(CGPoint(x: 8, y: 26))
    
    // *********************
    // **** Bottom side ****
    // *********************
    
    // segment 10: line
    path.closePath() // draws the final line to close the path
    
    return path
}
    
