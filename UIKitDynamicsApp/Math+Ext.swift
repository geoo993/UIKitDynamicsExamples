//
//  MathOperations.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 26/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit


extension Int {
    
    public static func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
    
}

extension CGFloat {
    
    public static func random(min: CGFloat, max: CGFloat) -> CGFloat {
        
        let rand = CGFloat(arc4random()) / CGFloat(UINT32_MAX)
        let minimum = min < max ? min : max 
        return  rand * abs(min - max) + minimum
    }
    
    public static func clampWrapAroundZero(p: CGFloat, max: CGFloat) -> CGFloat {
        let xWrapped = p % max
        return p >= 0.0 ? xWrapped : xWrapped + max - 1
        
    }
    public static func distanceBetween(p1 : CGPoint, p2 : CGPoint) -> CGFloat {
        let dx : CGFloat = p1.x - p2.x
        let dy : CGFloat = p1.y - p2.y
        return sqrt(dx * dx + dy * dy)
    }

    public static func clampf(value: CGFloat, minimum:CGFloat, maximum:CGFloat) -> CGFloat {
        
        if value < minimum { return minimum }
        if value > maximum { return maximum }
        return value
    }
    
    public static func angleFrom(point1:CGPoint,point2:CGPoint) -> CGFloat
    {
        
        let Pi = CGFloat(M_PI)
        let distX = point2.x - point1.x;
        let distY = point2.y - point1.y;
        let angle = atan2(distX,distY);
        let radiansToDegrees = 180 / Pi
        
        let angleDegrees = angle * radiansToDegrees
        return angleDegrees
    }

    public static func rotateToward(shapePos:CGPoint, rotateTo: CGPoint) -> CGFloat
    {
//        //type1
//        let DegreesToRadians = M_PI / 180
//        let deltaX = rotateTo.x - shapePos.x
//        let deltaY = rotateTo.y - shapePos.y
//        let angle = atan2(deltaY, deltaX)
//        let zRotation = angle - 90 * CGFloat(DegreesToRadians)
//        
//        //type2
//        let radians = atan2(rotateTo.y - shapePos.y, rotateTo.x - shapePos.x);
//        let degrees = CGFloat(radians) / CGFloat(M_PI / 180) + 90;
//        let zRotation = degrees
//        
        
        //type3
        let rotationOffset: CGFloat = -CGFloat(M_PI/2.0)
        let ang = atan2(rotateTo.y-shapePos.y, rotateTo.x-shapePos.x)
        let zRotation = ang + rotationOffset
        return zRotation
    }

}
