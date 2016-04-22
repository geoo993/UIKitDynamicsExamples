//
//  PhonemesThirdViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 22/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhonemesThirdViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var fontsize : CGFloat = 20
    
    var label = UILabel()
    var shadowLayer: CALayer = CALayer()
    
    let textViewX : CGFloat = 40
    let textViewY : CGFloat = 300
    
    var textView : UITextView!
    
    var phonemesLabels = [UILabel]()
    var shapeLayer = [CAShapeLayer]()
    
    var animator:UIDynamicAnimator? = nil
    var snapBehavior: UISnapBehavior!
    var snapPoints = [CGPoint]()
    
    
    let radiusPoint = UIView()
    
    var shapesArray = [UIView]()
    
    var previousRect = CGRect()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        
        self.textView = UITextView(frame: CGRect(x: textViewX, y: textViewY, width: 300, height: 40))
        textView.clipsToBounds = false
        textView.text = "Hi George, Welcome Home"
        textView.font = textView.font?.fontWithSize(fontsize)
        textView.editable = false
        self.view.addSubview(textView)
        textView.layer.addSublayer(self.shadowLayer)
        
        self.animator = UIDynamicAnimator(referenceView:textView)
        
        
        //let phonemesColor = UIColor.randomColor()
        
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.0
        
        longPressGesture
            .rx_event
            .subscribeNext { tap in
                
                let location = tap.locationInView(self.textView)
                //let text = tap.view as? UITextView
                
                switch tap.state {
                case .Began: 
                    
                    guard let textPosition = self.textView.closestPositionToPoint(location),
                        let wordRange = self.textView.tokenizer.rangeEnclosingPosition(textPosition, withGranularity: UITextGranularity.Word, inDirection: 0),
                        let highlightedText = self.textView.textInRange(wordRange) else { return }
                    
                    var rect = self.textView.firstRectForRange(wordRange)
                    
                    
                   
                    Observable.of(rect)
                    .map { r in 
                    
                        if rect !=  self.previousRect {
                                self.previousRect = rect
                                print("not equal")
                                
                                //return true
                        }else{
                                print("equal")
                                //return false
                            self.previousRect = CGRectZero
                        }
                        
                        
                       //rect !=  self.previousRect ?? self.previousRect = rect : self.previousRect = CGRectZero
                        
                    }
                    .subscribeNext{_ in 
                        
                        print("current ",rect, "previous ",self.previousRect)
                    }
                    
                    //print("word rect", rect, highlightedText)
                    //print("began", location)
                case .Ended: 
                    print("ended", location)
                default:
                    print("tap ")
                }   
            }.addDisposableTo(disposeBag)
        textView.addGestureRecognizer(longPressGesture)
        
        
    }
    
}