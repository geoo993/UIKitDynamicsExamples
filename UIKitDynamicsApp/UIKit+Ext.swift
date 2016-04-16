//
//  UIKit+Ext.swift
//  AlienPhonicsSpriteKit
//
//  Created by GEORGE QUENTIN on 26/02/2016.
//  Copyright © 2016 GEORGE QUENTIN. All rights reserved.
//

import Foundation
import UIKit

public struct ColorComponents {
    var r:CGFloat, g:CGFloat, b:CGFloat, a:CGFloat
}


extension UIColor {
    public static func randomColor() -> UIColor {
        
        return UIColor.init(red: CGFloat.random(0.0, max: 1.0), green: CGFloat.random(0.0,max: 1.0), blue: CGFloat.random(0.0,max: 1.0), alpha: 1)
    }

    //type 1
    public func getComponents() -> ColorComponents {
        if (CGColorGetNumberOfComponents(self.CGColor) == 2) {
            let cc = CGColorGetComponents(self.CGColor);
            return ColorComponents(r:cc[0], g:cc[0], b:cc[0], a:cc[1])
        }
        else {
            let cc = CGColorGetComponents(self.CGColor);
            return ColorComponents(r:cc[0], g:cc[1], b:cc[2], a:cc[3])
        }
    }
    
    public static func interpolateRGBColorWithWhite(start:UIColor,end:UIColor, fraction:CGFloat) -> UIColor
    {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = start.getComponents()
        let c2 = end.getComponents()
        
        let r: CGFloat = CGFloat(c1.r + (c2.r - c1.r) * f)
        let g: CGFloat = CGFloat(c1.g + (c2.g - c1.g) * f)
        let b: CGFloat = CGFloat(c1.b + (c2.b - c1.b) * f)
        let a: CGFloat = CGFloat(c1.a + (c2.a - c1.a) * f)
        
        return UIColor.init(red: r, green: g, blue: b, alpha: a)
    }
    
    //type 2
    public static func interpolateRGBColorTo(start:UIColor,end:UIColor, fraction:CGFloat) -> UIColor
    {
        var f = max(0, fraction)
        f = min(1, fraction)
        
        let c1 = CGColorGetComponents(start.CGColor)
        let c2 = CGColorGetComponents(end.CGColor)
        
        let r: CGFloat = CGFloat(c1[0] + (c2[0] - c1[0]) * f)
        let g: CGFloat = CGFloat(c1[1] + (c2[1] - c1[1]) * f)
        let b: CGFloat = CGFloat(c1[2] + (c2[2] - c1[2]) * f)
        let a: CGFloat = CGFloat(c1[3] + (c2[3] - c1[3]) * f)
        
        return UIColor.init(red:r, green:g, blue:b, alpha:a)
    }
    public static func hueInterpolateColors(numColors:Int,value:Int, saturation:CGFloat,brightness:CGFloat,alpha:CGFloat) -> UIColor
    {
        let colors = 
            Array(0..<numColors)
                .map { CGFloat($0) * (1.0 / CGFloat(numColors) )}
                .map { cgfloat -> UIColor in
                    let color = UIColor(hue: cgfloat, saturation: saturation, brightness: brightness, alpha: alpha)
                return color
        }
        return colors[value]
      
    }
}
