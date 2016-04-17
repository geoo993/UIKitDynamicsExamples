//
//  GesturesViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 14/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class GesturesViewController: UIViewController {
    
    var disposeBag = DisposeBag()

    var animator:UIDynamicAnimator? = nil
    var snapBehavior: UISnapBehavior!
    var frameMidX :CGFloat = CGFloat()
    var frameMidY :CGFloat = CGFloat()
    
    let boxWidth : CGFloat = 200
    let boxHeight : CGFloat = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        
        animator = UIDynamicAnimator(referenceView:self.view)
        
        frameMidX = super.view.bounds.size.width/2
        frameMidY = super.view.bounds.size.height/2
        
        print(super.view.bounds.size.height)
        
        let swipeB = UIButton(frame: CGRect(x: frameMidX-(boxWidth/2), y: frameMidY-(225), width: boxWidth, height: boxHeight))
        swipeB.setTitle("SWIPE", forState: UIControlState.Normal)
        swipeB.backgroundColor = UIColor.randomColor()
        self.view.addSubview(swipeB)
        
        let swipeGesture = UISwipeGestureRecognizer()
        swipeGesture.addTarget(self, action: #selector(GesturesViewController.swipedView))
        swipeB.addGestureRecognizer(swipeGesture)
        swipeB.userInteractionEnabled = true
        
        
        let tapB = UIButton(frame: CGRect(x: frameMidX-(boxWidth/2), y: frameMidY-(100), width: boxWidth, height: boxHeight))
        tapB.setTitle("TAP", forState: UIControlState.Normal)
        tapB.backgroundColor = UIColor.randomColor()
        self.view.addSubview(tapB)
        let tap = UITapGestureRecognizer(target: self, action: #selector(GesturesViewController.onTap(_:)))
        tapB.addGestureRecognizer(tap)
        tapB.userInteractionEnabled  = true

        let panB = UIButton(frame: CGRect(x: frameMidX-(boxWidth/2), y: frameMidY+(25), width: boxWidth, height: boxHeight))
        panB.setTitle("PAN", forState: UIControlState.Normal)
        panB.backgroundColor = UIColor.randomColor()
        self.view.addSubview(panB)
        let pan = UIPanGestureRecognizer(target: self, action: #selector(GesturesViewController.onPan(_:)))
        panB.addGestureRecognizer(pan)
        panB.userInteractionEnabled  = true
        
        
        let longPressB = UIButton(frame: CGRect(x: frameMidX-(boxWidth/2), y: frameMidY+(150), width: boxWidth, height: boxHeight))
        longPressB.setTitle("LONG PRESS", forState: UIControlState.Normal)
        longPressB.backgroundColor = UIColor.randomColor()
        self.view.addSubview(longPressB)
        
//        let longPressGesture = UILongPressGestureRecognizer()
//        longPressGesture.minimumPressDuration = 1.0
//        longPressGesture.addTarget(self, action: #selector(GesturesViewController.longPressedView))
//        longPressB.addGestureRecognizer(longPressGesture)
//        longPressB.userInteractionEnabled = true
        
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 1.0
        
        longPressGesture.rx_event
            .subscribeNext { lPress in  
                
                let point = lPress.locationInView(self.view);
                let button = lPress.view as! UIButton 
                
                switch lPress.state {
                case .Began: 
                
                    button.backgroundColor = UIColor.randomColor()
                    
                    let tapAlert = UIAlertController(title: "Long Pressed", message: "You just long pressed the long press button", preferredStyle: UIAlertControllerStyle.Alert)
                    tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
                    self.presentViewController(tapAlert, animated: true, completion: nil)
                    
                print("Began", point)
                default:
                    print(longPressGesture)
                }
                
            }.addDisposableTo(disposeBag)
    
        longPressB.addGestureRecognizer(longPressGesture)
        longPressB.userInteractionEnabled = true
        //self.view.addGestureRecognizer(dragGesture)
     
        
    }
    
    func swipedView(swipe: UISwipeGestureRecognizer){
        
        //let location = swipe.locationInView(self.view)
        
        let tapAlert = UIAlertController(title: "Swiped", message: "You just swiped the swipe view", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
    }
    
    func onTap(tap: UITapGestureRecognizer) {
        
        let location = tap.locationInView(self.view)
        //let buttonTag = tap.view?.tag
        let button = tap.view as! UIButton  // buttonTag as! UIButton 
        button.backgroundColor = UIColor.randomColor()
        print(location )
        
        let tapAlert = UIAlertController(title: "Tapped", message: "You just tapped the tap button", preferredStyle: UIAlertControllerStyle.Alert)
        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
        self.presentViewController(tapAlert, animated: true, completion: nil)
        
    }
//    
//    func longPressedView(press: UILongPressGestureRecognizer){
//        
//        let button = press.view!
//        
//        button.backgroundColor = UIColor.randomColor()
//        
//        let tapAlert = UIAlertController(title: "Long Pressed", message: "You just long pressed the long press button", preferredStyle: UIAlertControllerStyle.Alert)
//        tapAlert.addAction(UIAlertAction(title: "OK", style: .Destructive, handler: nil))
//        self.presentViewController(tapAlert, animated: true, completion: nil)
//    }
//    
    func onPan(pan: UIPanGestureRecognizer) {
        
        let location = pan.locationInView(self.view);
        let button = pan.view as! UIButton 
        
        ////type 1
//        if pan.state == UIGestureRecognizerState.Began {
//            button.center = pan.locationOfTouch(0, inView: self.view);
//        }
//        
//        if pan.state == UIGestureRecognizerState.Changed {
//            button.center = pan.locationOfTouch(0, inView: self.view)
//        }
//        
//        if pan.state == UIGestureRecognizerState.Ended {
//            
//            print(location)
//        }
        
        ////type 2
        
        switch pan.state {
        case .Began: 
            button.center = pan.locationOfTouch(0, inView: self.view);
        //print("Began", location)
        case .Changed: 
            button.center = pan.locationOfTouch(0, inView: self.view)
        //print("Changed", location)
        case .Ended: 
            
            if (self.snapBehavior != nil) {
                self.animator?.removeBehavior(self.snapBehavior)
            }
            
            self.snapBehavior = UISnapBehavior(item: button, snapToPoint: CGPointMake(self.frameMidX, frameMidY +
                (25 + (boxHeight/2))))
            self.animator?.addBehavior(self.snapBehavior)
            print("Ended", location) 
        default:
            print(pan)
        }

        ////type 3
//        self.view.bringSubviewToFront(pan.view!)
//        let translation = pan.translationInView(self.view)
//        button.center = CGPointMake(button.center.x + translation.x, button.center.y + translation.y)
//        pan.setTranslation(CGPointZero, inView: self.view)
//        
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        guard let theTouch = touches.first! as? UITouch else {return}
        let location = theTouch.locationInView(self.view)
        
        let touchCount = touches.count
        let tapCount = theTouch.tapCount
        
//        // find a object at the tap location
//        self.wordsLabels.forEach { w in 
//            
//            // Convert the location of the obstacle view to this view controller's view coordinate system
//            let objectTouch = self.view.convertRect(w.frame, fromView: w.superview)
//            
//            // Check if the touch is inside the obstacle view
//            if CGRectContainsPoint(objectTouch, location) {
//                
//                
//                print("object", objectTouch)
//            }
//            
//        }
        
        
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //NSLog("Starting gravity")
    }
  
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}