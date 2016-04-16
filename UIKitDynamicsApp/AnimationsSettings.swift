//
//  AnimationsSettings.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 13/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit

struct AnimationSettings {
    var gravity: CGFloat = 0.1
    var elasticity: CGFloat = 0.8
    var pushMagnitude: CGFloat = 1.0
    var snapDamping: CGFloat = 0.5
    var squareDensity: CGFloat = 0.5
    var friction: CGFloat = 0.05
    var resistance: CGFloat = 0.05
    var allowRotation: Bool = true
}