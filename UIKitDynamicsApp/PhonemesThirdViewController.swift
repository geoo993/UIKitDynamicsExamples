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
    
    var label = UILabel()
    var shadowLayer: CALayer = CALayer()
    
    var fontsize : CGFloat = 20
    let textViewX : CGFloat = 40
    let textViewY : CGFloat = 300
    
    var textView : UITextView!
    
    var phonemesLabels = [UILabel]()
    var shapeLayer = [CAShapeLayer]()
    
    var animator:UIDynamicAnimator? = nil
    var snapPoints = [CGPoint]()
    var shapesArray = [UIView]()
    
    let radiusPoint = UIView()
    
    var previousRect = CGRect()
    var tickIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        
        let text = "Biff got the eggs, she put them in the box. The hens ran up. Chip fed Them."
        let textSize : Int = text.characters.count
        self.textView = UITextView(frame: CGRect(x: textViewX, y: textViewY, width: 300, height: CGFloat(textSize + 10)))
        textView.clipsToBounds = false
        textView.text = text
        textView.font = textView.font?.fontWithSize(fontsize)
        textView.editable = false
        self.view.addSubview(textView)
        
        self.animator = UIDynamicAnimator(referenceView:textView)
        
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
                    
                    let rect = self.textView.firstRectForRange(wordRange)
                    let phonemesColor = UIColor.randomColor()
                    self.tickIndex = 0
                    
                    
                    Observable.of(rect)
                    .map { r -> Bool in 
                        return rect != self.previousRect ? true : false
                    }
                    .map{ trueFalse -> Bool in 
                        
                        if trueFalse == true {
                            
                            self.previousRect = rect; //print("not equal")
                            
                            self.addLayerOnWord(rect, inTextView: self.textView, word: highlightedText,fontSize: self.fontsize,roundedCorners: 5,alpha: 0.5)
                            
                            let bDotLength : CGFloat = 10
                            let bDotX : CGFloat = rect.midX - (bDotLength/2)
                            let bDotY : CGFloat = self.textView.bounds.size.height
                            self.addRadiusPoint(CGRect(x: bDotX, y: bDotY, width: bDotLength, height: bDotLength),color: phonemesColor)
                            
                            return true
                        } else {
                            
                            self.previousRect = CGRectZero; //print("equal")
                            self.removeEverythingOnWord()
                            
                            return false
                        }
                    
                        
//                        switch trueFalse {
//                            case true: 
//                            self.previousRect = rect; //print("not equal")
//                            
//                            self.addLayerOnWord(rect, inTextView: self.textView, word: highlightedText,fontSize: self.fontsize,roundedCorners: 5,alpha: 0.5)
//                            
//                            let bDotLength : CGFloat = 10
//                            let bDotX : CGFloat = rect.midX - (bDotLength/2)
//                            let bDotY : CGFloat = self.textView.bounds.size.height
//                            self.addRadiusPoint(CGRect(x: bDotX, y: bDotY, width: bDotLength, height: bDotLength),color: UIColor.clearColor())
//                            
//                            case false: 
//                            self.previousRect = CGRectZero; //print("equal")
//                            self.removeEverythingOnWord()
//                        }
//                        //print(trueFalse, "current ",rect, "previous ",self.previousRect)
//                        return  trueFalse
                        
                        
                    }
                    .map { onlyTrue -> [String] in 
                        
                        var phonemes = [String]()
                        
                        if onlyTrue == true {
                            
                            let wordModel = WordModel()
                            wordModel.getPho()
                            phonemes = highlightedText.lowercaseString.characters
                                .map { letter -> String in
                                    return String(letter)
                                }
                                .map { letter in
                                    return wordModel.chosenLetter[letter]![Int.random(0, max: (wordModel.chosenLetter[letter]!.count)-1)]
                            }  
                            
                            //print("truee ....", phonemes)
                        }
                        
                        return phonemes
                    }
                    .map { phonemes -> ([CGPoint],[UILabel],CGFloat) in
                           
                        self.phonemesLabels.forEach ({ pho in
                            pho.removeFromSuperview()
                        })
                        
                        let phonemeSnapPosition = 
                            CGPoint(x: rect.origin.x, y: rect.origin.y - (self.textView.bounds.size.height/2))
                        
                        let dist = CGFloat.distanceBetween(self.radiusPoint.center, p2: phonemeSnapPosition)
                        let increaseBy : CGFloat = 40 
                        let newRadius = dist + increaseBy
                        let expansionRatio = newRadius / dist
                        
                        let snapPointPhonemeLabelsArray = Array(0 ..< phonemes.count).map { letterIdx -> (CGPoint, UILabel) in
                            
                            let phoWidth = (rect.size.width / CGFloat(phonemes.count)) 
                            let phoWidthExp = (rect.size.width / CGFloat(phonemes.count)) * expansionRatio
                            
                            let phoHeight = rect.size.height
                            let phoX = ((self.textViewX + rect.origin.x ) + (CGFloat(letterIdx) * phoWidth)) + 
                                    (0.5 * phoWidth) 
                            let phoY = self.textViewY-phoHeight + (rect.size.height/2)
                            
                            let snapPoint = CGPointMake( phoX, phoY)
                            
                            let frame = CGRect(x: rect.midX, y: rect.minY, width: phoWidthExp, height: rect.size.height)
                            
                            let phonemeLabel = self.createBox(frame, color:phonemesColor, text: phonemes[letterIdx],fontSize: 8.0,roundedCorners: 2,alpha: 1)
                            return (snapPoint, phonemeLabel)
                        }
                        
                        self.snapPoints = snapPointPhonemeLabelsArray.map { point, label in return point }
                        self.phonemesLabels = snapPointPhonemeLabelsArray.map { point, label in return label }
                        
                        return (self.snapPoints,self.phonemesLabels,newRadius)
                    }
                    .subscribeNext{ (snapPoints, allPho, radius) in
                        
                        Array(0 ..< allPho.count).map { idx -> Double in 
                            
                            allPho[idx].hidden = true
                            let timeDelays = Double.roundToPlaces(Double.random(0.0, max: 1.0),places: 1)
                            //print(timeDelays)
                            
                            return timeDelays
                        }.toObservable() 
                        .scan(0, accumulator: { acum, elem in
                                acum + elem})
                        .flatMap { delay -> Observable<Double>  in 
                            
                            return Observable<Int64>
                            .timer(delay, scheduler: MainScheduler.instance)
                            .map { _ in delay }
                            
                        }
                        .subscribeNext { tick in 
                            print(tick, "index: ",self.tickIndex) 
                            
                            allPho[self.tickIndex].hidden = false
                            let pho = snapPoints[self.tickIndex]
                            let p0 = CGPoint(x: pho.x-self.textViewX,y: pho.y-self.textViewY)
                            let p1 = self.radiusPoint.center
                            
                            let angle = CGFloat.pointPairToBearingRadians(p0,endingPoint: p1)
                            
                            let newPoint = 
                                CGPoint(
                                    x: radius * cos(angle) + p1.x,
                                    y: radius * -sin(angle) + p1.y) 
                            
                            let snapBehavior =  UISnapBehavior(item: allPho[self.tickIndex], snapToPoint: newPoint) 
                            self.animator?.addBehavior(snapBehavior)
                           
                                
                            self.tickIndex += 1
                            //print(self.tickIndex)
                        }.addDisposableTo(self.disposeBag)
                
                    }.addDisposableTo(self.disposeBag)
                    //print("began", location)
                case .Ended: 
                    print("ended", location)
                default:
                    print("tap ")
                }   
            }.addDisposableTo(disposeBag)
        textView.addGestureRecognizer(longPressGesture)
        
        
    }
    
    func createBox(frame: CGRect, color: UIColor, text: String, fontSize: CGFloat, roundedCorners: CGFloat,alpha:CGFloat) -> UILabel {
        
        let newBox = UILabel()
        newBox.frame = frame
        newBox.backgroundColor = color
        newBox.textColor = UIColor.blackColor()
        newBox.textAlignment = NSTextAlignment.Center        
        newBox.text = text
        newBox.font = UIFont(name: "Helvetica", size: fontSize)
        newBox.alpha = alpha
        newBox.layer.cornerRadius = roundedCorners
        newBox.layer.masksToBounds = true
        
        self.textView.addSubview(newBox)
        return newBox
    }
    
    func addRadiusPoint(frame:CGRect, color: UIColor)
    {
        self.radiusPoint.frame = frame
        self.radiusPoint.backgroundColor = color
        self.radiusPoint.layer.cornerRadius = 3
        self.radiusPoint.layer.masksToBounds = true
        self.textView.addSubview(self.radiusPoint)
    }
    func addLayerOnWord(rect:CGRect,inTextView: UITextView, word:String,fontSize:CGFloat,roundedCorners:CGFloat,alpha:CGFloat)
    {
        
        /** Add Shadow */
        
        let frame = CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, rect.size.height)
        
        //print(rect.origin,self.label.frame.origin)
        
        self.shadowLayer.frame = frame
        self.shadowLayer.cornerRadius = roundedCorners // 5
        self.shadowLayer.backgroundColor = UIColor.yellowColor().CGColor
        self.shadowLayer.shadowColor = UIColor.blackColor().CGColor
        self.shadowLayer.shadowOpacity = 0.6
        self.shadowLayer.shadowOffset = CGSizeMake(1, 1)
        self.shadowLayer.shadowRadius = 3
        
        /** Label */
        self.label.frame = frame
        self.label.textColor = UIColor.blackColor()
        self.label.textAlignment = NSTextAlignment.Center        
        self.label.text = word
        self.label.font = UIFont(name: "Helvetica", size: fontSize)
        self.label.alpha = alpha
        
        
        inTextView.layer.addSublayer(self.shadowLayer)
        inTextView.addSubview(self.label)
    }
    func removeEverythingOnWord()
    {
        self.label.removeFromSuperview()
        self.shadowLayer.removeFromSuperlayer()
        self.radiusPoint.removeFromSuperview()
        
        self.animator?.removeAllBehaviors()
    }
    
    



}

