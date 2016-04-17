//
//  GameViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 13/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa
import CoreMotion

class SnapingViewController: UIViewController,UICollisionBehaviorDelegate {

    var disposeBag = DisposeBag()
    
    let motionQueue = NSOperationQueue()
    let motionManager = CMMotionManager()
    
    var animationSettings = AnimationSettings()
    var animator:UIDynamicAnimator? = nil
    var gravity: UIGravityBehavior = UIGravityBehavior()
    var collider: UICollisionBehavior = UICollisionBehavior()
    var itemBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior()
    var pushBehavior : UIPushBehavior = UIPushBehavior()
    var snapBehavior: UISnapBehavior!
    
    
    var maxX : CGFloat = CGFloat()
    var maxY : CGFloat = CGFloat()
    let boxSize : CGFloat = 30.0
    var box : UIButton = UIButton()
    var boxes : Array<UIButton> = []
    var frameMidX : CGFloat =  CGFloat()
    var frameMidY : CGFloat =  CGFloat()
   
    let numberOfBoxes = 20
    
    func doesNotCollide(testRect: CGRect) -> Bool {
        
        for box : UIButton in boxes {
            let viewRect = box.frame;
            if(CGRectIntersectsRect(testRect, viewRect)) {
                return false
            }
        }
        return true
    }
  
    func randomFrame() -> CGRect {
        var guess = CGRectMake(9, 9, 9, 9)

        repeat {
           let guessX = CGFloat.random(boxSize, max: maxX)
           let guessY = CGFloat.random(boxSize, max: maxY)
           guess = CGRectMake(guessX, guessY, boxSize, boxSize)
        } while(!doesNotCollide(guess))

        return guess
    }

    func createBox(location: CGRect, color: UIColor, title: String) -> UIButton {
        
        let newBox = UIButton(frame: location)
        newBox.backgroundColor = UIColor.redColor()
        newBox.backgroundColor = color
        newBox.setTitle(title, forState: UIControlState.Normal)
        newBox.titleLabel?.font = newBox.titleLabel?.font.fontWithSize(10.0)

//        view.addSubview(newBox)
//        addBoxToBehaviors(newBox)
//        boxes.append(newBox)
        return newBox
    }
 
  
    func generateAndAddToViewBoxes() -> [UIButton] {
        
        return Array(0 ..< numberOfBoxes).map { i in
            let frame = randomFrame()
            let color = UIColor.randomColor()
            let box = createBox(frame, color: color,title: "\(i+1)" )
            view.addSubview(box)
            addBoxToBehaviors(box)
            return box
        }
    }
   
    func createAnimatorStuff() {
        animator = UIDynamicAnimator(referenceView:self.view);
        
        gravity.gravityDirection = CGVectorMake(0, 0.8)
        animator?.addBehavior(gravity);
        
        collider.translatesReferenceBoundsIntoBoundary = true
        animator?.addBehavior(collider)
        
        itemBehavior.allowsRotation = animationSettings.allowRotation
        itemBehavior.friction = animationSettings.friction
        itemBehavior.elasticity = animationSettings.elasticity
        animator?.addBehavior(itemBehavior)
        
        let vx = CGFloat.random(-3, max: 3)
        let vy = CGFloat.random(0, max: 3)
        pushBehavior.pushDirection = CGVector(dx: vx, dy: vy)
        //pushBehavior.setAngle(CGFloat(M_PI / -2) , magnitude: 5)
        animator?.addBehavior(pushBehavior)
        
        
    }
    
    func addBoxToBehaviors(box: UIView) {
        
        gravity.addItem(box)
        collider.addItem(box)
        itemBehavior.addItem(box)
        pushBehavior.addItem(box)
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        
        frameMidX = CGRectGetMidX(self.view.bounds) 
        frameMidY = CGRectGetMidY(self.view.bounds)

        maxX = super.view.bounds.size.width - boxSize;
        maxY = super.view.bounds.size.height - boxSize;
       
        createAnimatorStuff()
        boxes = generateAndAddToViewBoxes()
        
      
//        let tapLeft = UITapGestureRecognizer()
//        let tapRight = UITapGestureRecognizer()
//        Observable.combineLatest(tapLeft.rx_event, tapRight.rx_event) { ($0, $1) }  
        
        
        boxes.forEach { b in
            
            let longPressGesture = UILongPressGestureRecognizer()
            longPressGesture.minimumPressDuration = 0.0
            longPressGesture.rx_event
                .subscribeNext { tap in 
                
                let location = tap.locationInView(self.view)
                let button = tap.view as! UIButton 
              
                switch tap.state {
                case .Began: 
                    
                if (self.snapBehavior != nil) {
                    self.animator?.removeBehavior(self.snapBehavior)
                }
                
                self.snapBehavior = UISnapBehavior(item: button, snapToPoint: CGPointMake(self.frameMidX, self.frameMidY))
                self.snapBehavior.damping = 1.0
                self.animator?.addBehavior(self.snapBehavior)
                
                    print("began",location)
                case .Changed: 
                    print("changed",location)
                case .Ended: 
                    print("ended",location)
                default:
                    print("tapp ")
                }
            }.addDisposableTo(disposeBag)
            b.addGestureRecognizer(longPressGesture)
            b.userInteractionEnabled = true
            
//            let panGesture = UIPanGestureRecognizer()
//            
//            panGesture.rx_event
//                .subscribeNext { pan in  
//                
//                _ = pan.locationInView(self.view);
//                let button = pan.view as! UIButton 
//                
//                self.animator?.removeAllBehaviors()
//                
//                switch pan.state {
//                case .Began: 
//                    ////                    let b = self.createBox(CGRect(x: point.x-(self.boxSize/2), y: point.y-(self.boxSize/2), width: self.boxSize, height: self.boxSize), color: UIColor.randomColor(),title: "\( self.boxes.count+1)" )
//                    ////                    self.view.addSubview(b)
//                    ////                    self.addBoxToBehaviors(b)
//                    ////                    self.boxes.append(b)
//                    ////                 
//                    
//                    
//                    button.center = pan.locationOfTouch(0, inView: self.view);
//                    //print("Began", point)
//                case .Changed: 
//                    button.center = pan.locationOfTouch(0, inView: self.view)
//                    //print("Changed", point)
//                case .Ended: 
//                    
//                    if (self.snapBehavior != nil) {
//                        self.animator?.removeBehavior(self.snapBehavior)
//                    }
//                    
//                    self.snapBehavior = UISnapBehavior(item: button, snapToPoint: CGPointMake(self.frameMidX, self.frameMidY))
//                    self.animator?.addBehavior(self.snapBehavior)
//                    
//                    //print("Ended", point) 
//                default:
//                    print(panGesture)
//                }
//
//            }.addDisposableTo(disposeBag)
//            
//            b.addGestureRecognizer(panGesture)
         
        }
        
    }
    
 
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        //NSLog("Starting gravity")
        //motionManager.startDeviceMotionUpdatesToQueue(motionQueue, withHandler: gravityUpdated)
    }
    
    override func viewDidDisappear(animated: Bool)  {
        super.viewDidDisappear(animated)
       // NSLog("Stopping gravity")
       // motionManager.stopDeviceMotionUpdates()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}