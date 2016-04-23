//
//  PhonemesAndDotsViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 21/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class PhonemesAndDotsViewController: UIViewController {

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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        // print("text view")
        self.view.backgroundColor = UIColor.randomColor()
        
        self.textView = UITextView(frame: CGRect(x: textViewX, y: textViewY, width: 300, height: 40))
        textView.clipsToBounds = false
        textView.text = "Hi George, Welcome Home"
        textView.font = textView.font?.fontWithSize(fontsize)
        textView.editable = false
        self.view.addSubview(textView)
        textView.layer.addSublayer(self.shadowLayer)
     
        self.animator = UIDynamicAnimator(referenceView:textView)
        
        
        let phonemesColor = UIColor.randomColor()
        
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.0
        
        longPressGesture
            .rx_event
//            .doOnNext { tap in
//                
//                let location = tap.locationInView(self.textView)
//                //let text = tap.view as? UITextView
//                
//                switch tap.state {
//                case .Began: 
//                    
//                    guard let textPosition = self.textView.closestPositionToPoint(location),
//                        let wordRange = self.textView.tokenizer.rangeEnclosingPosition(textPosition, withGranularity: UITextGranularity.Word, inDirection: 0),
//                        let highlightedText = self.textView.textInRange(wordRange) else { return }
//                    
//                    let rect = self.textView.firstRectForRange(wordRange)
//                    //print("word rect", rect, highlightedText)
//                    
//                    
//                    print("began", location)
//                case .Changed: 
//                    print("changed",location)
//                case .Ended: 
//                    print("ended",location)
//                default:
//                    print("tap ")
//                }
//            }
            .subscribeNext { tap in 
                
                let location = tap.locationInView(self.textView)
                let text = tap.view as? UITextView
                
                switch tap.state {
                case .Began: 
                    
                    
                    guard let textPosition = self.textView.closestPositionToPoint(location),
                        let wordRange = self.textView.tokenizer.rangeEnclosingPosition(textPosition, withGranularity: UITextGranularity.Word, inDirection: 0),
                        let highlightedText = self.textView.textInRange(wordRange) else { return }
                    
                    let rect = self.textView.firstRectForRange(wordRange)
                    //print("word rect", rect, highlightedText)
                    
                    
                    
                    self.highlightWord(rect,inTextView: self.textView,word: highlightedText)
                    
                    self.phonemesLabels.forEach ({ pho in
                        pho.removeFromSuperview()
                    })
                    
                    let wordModel = WordModel()
                    wordModel.getPho()
                    let phonemes = highlightedText.lowercaseString.characters
                        .map { letter -> String in
                            return String(letter)
                        }
                        .map { letter in
                            return wordModel.chosenLetter[letter]![Int.random(0, max: (wordModel.chosenLetter[letter]!.count)-1)]
                    }  
                    
                    let bDotLength : CGFloat = 10
                    //let bDotX : CGFloat = rect.origin.x + (rect.size.width*0.5) - (bDotLength/2)
                    let bDotX : CGFloat = rect.midX - (bDotLength/2)
                    //print("bDotX =", bDotX, "rect.midX ", rect.midX)
                    let bDotY : CGFloat = (rect.origin.y + (bDotLength/2)) + 50
                    self.radiusPoint.frame = CGRect(x: bDotX, y: bDotY, width: bDotLength, height: bDotLength)
                    self.radiusPoint.backgroundColor = phonemesColor
                    self.radiusPoint.layer.cornerRadius = 3
                    self.radiusPoint.layer.masksToBounds = true
                    self.textView.addSubview(self.radiusPoint)
                    
                    let phonemeSnapPosition = 
                        CGPoint(x: rect.origin.x, y: rect.origin.y - (self.textView.bounds.size.height/2))
                    
                    //print("phonemeSnapPosition", phonemeSnapPosition)
                    let dist = CGFloat.distanceBetween(self.radiusPoint.center, p2: phonemeSnapPosition)
                    let increaseBy : CGFloat = 40 
                    let newRadius = dist + increaseBy
                    let expansionRatio = newRadius / dist
                    //print("dist",dist)
                    
                    //print( highlightedText, phonemes.count,phonemes )
                    let snapPointPhonemeLabelsArray = Array(0 ..< phonemes.count).map { letterIdx -> (CGPoint, UILabel) in
                        
                        let phoWidth = (rect.size.width / CGFloat(phonemes.count)) 
                        let phoWidthExp = (rect.size.width / CGFloat(phonemes.count)) * expansionRatio

                        // Calculated mid-point
                        let phoHeight = rect.size.height
                        let phoX = 
                            ((self.textViewX + rect.origin.x ) + 
                                (CGFloat(letterIdx) * phoWidth)) + 
                                0.5 * phoWidth // Add midpoint offset
                        let phoY = self.textViewY-phoHeight + (rect.size.height/2)
                        
                        let snapPoint = CGPointMake( phoX, phoY)
                        
                        let frame = CGRect(x: rect.midX , y: rect.midY, width: phoWidthExp, height: rect.size.height)
                        
                        let phonemeLabel = self.createBox(frame, color:phonemesColor, text: phonemes[letterIdx],fontSize: 8.0,roundedCorners: 2,alpha: 1)
                        return (snapPoint, phonemeLabel)
                        
                    }
                    
                    
                    self.snapPoints = snapPointPhonemeLabelsArray.map { point, label in return point }
                    self.phonemesLabels = snapPointPhonemeLabelsArray.map { point, label in return label }
                    //print(self.snapPoints.map { $0 }, self.phonemesLabels.map{ $0.center })
                    
                    Array(0 ..< self.phonemesLabels.count)
                    .map { idx in 
                        
                        let pho = self.snapPoints[idx]
                        let p0 = CGPoint(x: pho.x-self.textViewX,y: pho.y-self.textViewY)
                        let p1 = self.radiusPoint.center
                        
                        let angle = CGFloat.pointPairToBearingRadians(p0,endingPoint: p1)
                      
                        let newPoint = 
                            CGPoint(
                                x: newRadius * cos(angle) + p1.x,
                                y: newRadius * -sin(angle) + p1.y) 
                        
                        //print("newPoint 1:", newPoint)
                        return UISnapBehavior(item: self.phonemesLabels[idx], snapToPoint: newPoint) 
                    }
                    .forEach { snapBehavior in
                        self.animator?.addBehavior(snapBehavior)
                    }
                    
                    
                    
//                    self.shapeLayer.forEach ({ line in
//                        line.removeFromSuperlayer()
//                    })
//                    
//                    self.snapPoints.enumerate().forEach { (idx, pho) in
//                        
//                        let p0 = CGPoint(x: pho.x-self.textViewX,y: pho.y-self.textViewY)
//                        let p1 = self.radiusPoint.center
//                        let angle = self.pointPairToBearingRadians(p0,endingPoint: p1)
//                        //print(angle)
//                        
//                        let increaseBy : CGFloat = 100 
//                        let newRadius = dist + increaseBy
//                        
//                        let movingXby = (p0.x-p1.x)/dist
//                        let newX = p0.x + (movingXby * increaseBy)
//                        
//                        let movingYby = (p0.y-p1.y)/dist
//                        let newY = p0.y + (movingYby * increaseBy)
                        //print("moving x by ",movingXby, " moving y by ", movingYby)
                        
//                        let newPoint = CGPoint(x: newX,y: newY) 
//                        let newPoint = 
//                            CGPoint(
//                                x: newRadius * cos(angle) + p1.x,
//                                y: newRadius * -sin(angle) + p1.y) 
                        //let newPoint = CGPoint(x: p0.x + (dist/2)*cos(angle),y: p0.y + (dist/2)*sin(angle))
//                        print("newPoint bezier:", newPoint)
//
//                        
//                        let path = UIBezierPath()
//                        path.moveToPoint(newPoint)
//                        path.addLineToPoint(p1)
//                        path.closePath() 
//                        // Create a CAShapeLayer
//                        let sLayer = CAShapeLayer()
//                        sLayer.path = path.CGPath
//                        sLayer.strokeColor = UIColor.randomColor().CGColor
//                        sLayer.fillColor = UIColor.clearColor().CGColor
//                        sLayer.lineWidth = 2.0
//                        self.textView.layer.addSublayer(sLayer)
//                        self.shapeLayer.append(sLayer)

                        
//                    }
                case .Changed: 
                    print("changed",location)
                case .Ended: 
                    print("ended",location)
                default:
                    print("tap ")
                }
            }.addDisposableTo(disposeBag)
        textView.addGestureRecognizer(longPressGesture)
    }
    
    func highlightWord(rect:CGRect,inTextView: UITextView, word:String)
    {
        
        /** Add Shadow */
        // self.shadowLayer.removeFromSuperlayer()
        let frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        
        //print(rect.origin,self.label.frame.origin)
        
        self.shadowLayer.frame = frame
        self.shadowLayer.cornerRadius = 5
        self.shadowLayer.backgroundColor = UIColor.yellowColor().CGColor
        self.shadowLayer.shadowColor = UIColor.blackColor().CGColor
        self.shadowLayer.shadowOpacity = 0.6
        self.shadowLayer.shadowOffset = CGSizeMake(1, 1)
        self.shadowLayer.shadowRadius = 3
        
        /** Label */
        self.label.removeFromSuperview()
        self.label = createBox(frame, color: UIColor.clearColor(), text: word, fontSize: self.fontsize-2, roundedCorners: 8,alpha: 0.5)
    
       
        //inTextView.layer.addSublayer(self.shadowLayer)
    }
    
    func createBox(frame: CGRect, color: UIColor, text: String, fontSize: CGFloat, roundedCorners: CGFloat,alpha:CGFloat) -> UILabel {
        
        let newBox = UILabel()
        newBox.frame = frame
        newBox.backgroundColor = color
        newBox.textColor = UIColor.blackColor()
        newBox.textAlignment = NSTextAlignment.Center        
        newBox.text = text
        newBox.font = UIFont(name: "Helvetica", size: fontSize)//newBox.font.fontWithSize(fontSize)
        newBox.alpha = alpha
        newBox.layer.cornerRadius = roundedCorners
        newBox.layer.masksToBounds = true
        
        self.textView.addSubview(newBox)
        return newBox
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