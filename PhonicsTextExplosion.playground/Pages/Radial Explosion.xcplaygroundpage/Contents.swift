//: [Previous](@previous)

import Foundation
import UIKit
var str = "Hello, playground"

let a = [0.0, 1.0, 2.0, 3.0, 4.0]


func pointPairToBearingDegrees(startingPoint: CGPoint, endingPoint:CGPoint) -> CGFloat
{
    let originPoint = CGPointMake(endingPoint.x - startingPoint.x, endingPoint.y - startingPoint.y) // get origin point to origin by subtracting end from start
    let bearingRadians : Float = atan2f(Float(originPoint.y), Float(originPoint.x)) // get bearing in radians
    var bearingDegrees : CGFloat = CGFloat(bearingRadians) * CGFloat(180.0 / M_PI) // convert to degrees
    bearingDegrees = (bearingDegrees > 0.0 ? bearingDegrees : (360.0 + bearingDegrees)) // correct discontinuity
    return bearingDegrees
}

func pointPairToBearingRadians(startingPoint: CGPoint, endingPoint:CGPoint) -> CGFloat
{
    let originPoint = CGPoint(x: endingPoint.x - startingPoint.x, y: endingPoint.y - startingPoint.y) // get origin point to origin by subtracting end from start
    let bearingRadians : Float = atan2f(Float(originPoint.y), Float(originPoint.x)) // get bearing in radians

    return CGFloat(bearingRadians)
}

let startPoint = CGPoint(x: 1.0, y: 1.0)
let endPoint = CGPoint(x: 2.0, y: 2.0)

let angle = pointPairToBearingDegrees(startPoint, endingPoint: endPoint)

let arr = Array(0..<180).map { Double($0) * M_PI / 180.0 }
//print(arr)
let x_length = arr.map { cos($0) }
let y_length = arr.map { sin($0) }

sin(3.14/4)

//: [Next](@next)
