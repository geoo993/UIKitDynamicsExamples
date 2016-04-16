//
//  ViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 08/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class TestViewController: UIViewController, UICollisionBehaviorDelegate {

    var animator : UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var collision: UICollisionBehavior!
    var itemBehavior: UIDynamicItemBehavior!
    
    var disposeBag = DisposeBag()
    //var obj : UIView!
    var obj : UIButton!
    var arrB : [UIButton] = []
    var snap: UISnapBehavior!
    var updateCount = 0
    var outline : UIView!
    var firstContact = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let time : RxTimeInterval = 0.1
        let timePeriod : RxTimeInterval = 1
        
        let cannonTimer : Observable<Int64>= Observable<Int64>.timer(time, period: timePeriod,scheduler: MainScheduler.instance)
        let cannonSubscription : Disposable?
       
        cannonSubscription = cannonTimer.subscribeNext { tick in 
            //print(tick)
           
            let b : UIButton = UIButton(frame: CGRect(x: 200, y: 120, width: 50, height: 50))
            b.setTitle("\(tick)", forState: UIControlState.Normal)
            b.backgroundColor = UIColor.randomColor()
            self.view.addSubview(b)
            self.arrB.append(b)
            
            print(self.arrB.count)
            self.animator = UIDynamicAnimator(referenceView: self.view)
           
            let vx = CGFloat.random(-4, max: 4)
            let vy = CGFloat.random(-4, max: -1)
            let pushBehavior = UIPushBehavior(items: [b], mode: .Instantaneous)
            pushBehavior.pushDirection = CGVector(dx: vx, dy: vy)
            self.animator.addBehavior(pushBehavior)
        
             
            
            for but in self.arrB {
                
                self.gravity = UIGravityBehavior(items: [but] )
                self.animator.addBehavior(self.gravity)
                
                let angle = Int(arc4random_uniform(20)) - 10
                self.itemBehavior = UIDynamicItemBehavior(items: [but])
                self.itemBehavior.friction = 0.2
                self.itemBehavior.allowsRotation = true
                self.itemBehavior.addAngularVelocity(CGFloat(angle), forItem: but)
                self.animator.addBehavior(self.itemBehavior)
                
                self.collision = UICollisionBehavior(items: [but])
                self.collision.collisionDelegate = self
                self.collision.translatesReferenceBoundsIntoBoundary = true
                self.animator.addBehavior(self.collision)
                

            }
            
            self.arrB
                .toObservable()
                .map{ UIBut in
             
//                    if (UIBut.center.y > 600)
//                    {
//                        UIBut.removeFromSuperview()
//                    
//                    }
                }
                .subscribeNext{ UIBut in
                   // print(UIBut)
            }
        }
            //collision.action = {
                
    //            if (self.updateCount % 3 == 0) {
    //                self.outline = UIView(frame: self.obj.bounds)
    //                self.outline.transform = self.obj.transform
    //                self.outline.center = self.obj.center
    //                
    //                self.outline.alpha = 0.5
    //               
    //                self.outline.backgroundColor = UIColor.clearColor()
    //                self.obj.backgroundColor = UIColor.randomColor()
    //                self.outline.layer.borderColor = self.obj.layer.presentationLayer()!.backgroundColor
    //                self.outline.layer.borderWidth = 1.0
    //                self.view.addSubview(self.outline)
    //                
    //            }
    //            
    //            self.updateCount += 1
                
                //print(self.updateCount % 3)
                
                //print("\(NSStringFromCGAffineTransform(self.arrB[i].transform)) \(NSStringFromCGPoint(self.arrB[i].center))")
            //}
        
       // }
      
//        obj.rx_tap
//        .subscribeNext {
//            self.animator.addBehavior(self.gravity)
//        }
//        .addDisposableTo(disposeBag)
        
        
        
        
        let pressGesture = UILongPressGestureRecognizer()
        pressGesture.minimumPressDuration = 0.0
      
        pressGesture.rx_event.subscribeNext { gesture in
            
            let point = gesture.locationInView(pressGesture.view)
 
            switch gesture.state {
            case .Began: 
 
            print("Began", point)
            case .Changed: 
                
            print("Changed",point)
            case .Ended: 
                
                
                
            print("Ended", point) 
            default:
                print(gesture)
            }
        }.addDisposableTo(disposeBag)
        
        self.view?.addGestureRecognizer(pressGesture)

        
        
    }
   
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

