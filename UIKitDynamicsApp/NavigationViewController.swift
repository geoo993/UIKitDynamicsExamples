//
//  NavigationViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 15/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return [UIInterfaceOrientationMask.Portrait,UIInterfaceOrientationMask.PortraitUpsideDown]
    }
    
    override func preferredInterfaceOrientationForPresentation() -> UIInterfaceOrientation {
        return .Portrait
    }
    
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
}