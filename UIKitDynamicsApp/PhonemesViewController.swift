//
//  PhonemesViewController.swift
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
import AVFoundation

class PhonemesViewController: UIViewController {
    
    let speech = AVSpeechSynthesizer()
    var disposeBag = DisposeBag()

    var animationSettings = AnimationSettings()
    
    var animator:UIDynamicAnimator? = nil
    var gravity: UIGravityBehavior = UIGravityBehavior()
    var collider: UICollisionBehavior = UICollisionBehavior()
    //var attachBehavior: UIAttachmentBehavior = UIAttachmentBehavior()
    var itemBehavior: UIDynamicItemBehavior = UIDynamicItemBehavior()
    var pushBehavior : UIPushBehavior = UIPushBehavior()
    var snapBehavior: UISnapBehavior!
    
    
    let startX : CGFloat = 40
    let startY : CGFloat = 200
    let width : CGFloat = 300
    let phonemesHeight : CGFloat = 40
    
    var wordsLabels = [UILabel]() 
    var phonemesLabels = [UILabel]() 
    var snapPoints = [CGPoint]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.randomColor()
        self.animator = UIDynamicAnimator(referenceView:self.view);
        //let viewW = super.view.bounds.size.width;
        //let viewH = super.view.bounds.size.height;
        
        let phonemesLayoutBox = UIView(frame: CGRect(x: startX, y: startY, width: width, height: phonemesHeight))
        phonemesLayoutBox.backgroundColor = UIColor.randomColor()
        self.view.addSubview(phonemesLayoutBox) 
        
        let textLayoutBox = UIView(frame: CGRect(x: startX, y: 400, width: width, height: (phonemesHeight * 3)))
        textLayoutBox.backgroundColor = UIColor.randomColor()
        textLayoutBox.alpha = 0.2
        self.view.addSubview(textLayoutBox) 
        
        let word = "biff got the eggs. she put them in the box"
        
        let wArr = wordList(word)
        print(wArr)
        print(wArr.count)
        
        
        for w in 0 ..< wArr.count {
            
            let squareGridNum = 4
            let wLength = Int(self.width) / squareGridNum
            //CGFloat(wordArr[w].characters.count * 10)
           
            let wX = Int(self.startX) + (w % squareGridNum) * (wLength)
            let wY = 400 + Int(w / squareGridNum) * Int(self.phonemesHeight)
            
            let frame = CGRect(x: CGFloat(wX), y: CGFloat(wY), width:CGFloat(wLength), height: self.phonemesHeight)
            self.wordsLabels.append( self.createBox(frame, color: UIColor.randomColor(), text: wArr[w]))
            
        }
     
       
        self.wordsLabels.enumerate().forEach { (idx, wordText) in
            
            let pressGesture = UILongPressGestureRecognizer()
            pressGesture.minimumPressDuration = 0.0
            pressGesture
                .rx_event
                // create phonemes explosion
                .doOnNext { gesture in
                    
                    let location = gesture.locationInView(pressGesture.view)
                    guard let label = gesture.view as? UILabel else { return }
                   
                    switch gesture.state {
                    case .Began: 
     
                        self.phonemesLabels.forEach ({
//                            if $0 is UILabel {
                                $0.removeFromSuperview()
//                            }
                        })
                      
                        let wordModel = WordModel()
                        wordModel.getPho()
                        let phonemes = label.text!.characters
                            .map { letter -> String in
                                return String(letter)
                            }
                            .map { letter in
                            
                            return wordModel.chosenLetter[letter]![Int.random(0, max: (wordModel.chosenLetter[letter]!.count)-1)]
                        }                 
                        print( label.text, phonemes.count, phonemes )
                        
                        for letter in 0 ..< phonemes.count {
                           
                            let widthOffset = (self.width) / CGFloat(phonemes.count)
                            let newX = self.startX + (CGFloat(letter) * widthOffset)
                            
                            self.snapPoints.append(CGPointMake( newX+(widthOffset/2) , self.startY+(self.phonemesHeight/2) ))
                            
                            let frame = CGRect(x: wordText.center.x, y: wordText.center.y, width: widthOffset, height: wordText.frame.size.height)
                            
                            //if let pho = phonemes[letter] {
                                self.phonemesLabels.append( self.createBox(frame, color: label.backgroundColor!, text: phonemes[letter]))
                            //}
                            
                           // print(phonemes.count)
                        }
    
                        
                        //print("began",location)
                    case .Changed: 
                        print("changed",location)
                    case .Ended: 
                        
                        for pho in 0 ..< self.phonemesLabels.count {
                            
                            self.snapBehavior = UISnapBehavior(item: self.phonemesLabels[pho], snapToPoint: self.snapPoints[pho])
                            self.animator?.addBehavior(self.snapBehavior)
                            
                        }
                        
                        self.wordsLabels.forEach { otherLabel in
                            if otherLabel != label
                            {
                                UIView.animateWithDuration(0.5) {
                                    otherLabel.alpha = 0.0
                                } 
                            }
                            
                        }
                        
                        print(self.phonemesLabels.count)
                        print("ended",location)
                    default:
                        print("tap ")
                    }
                }
                // fade other out labels
                .doOnNext { gesture in 
                    
//                    var otherLabels = Array(self.wordsLabels)
//                    otherLabels.removeAtIndex(idx)
//                    otherLabels.forEach { otherLabel in
//                        UIView.animateWithDuration(0.5) {
//                            otherLabel.alpha = 0.0
//                        }
//                    }
                    
                    //print(self.phonemesLabels.count)
                }
//                // collapse phonemes
                .flatMap { gesture -> Observable<Int64> in
                    // say phoneme
//                    let utt = AVSpeechUtterance(string: self.phonemesLabels[0].text!)
                    // say word
                    //let utt = AVSpeechUtterance(string: wordText.text!)

                    //self.speech.speakUtterance(utt)
                     
                  
                    return Observable<Int64>
                        .timer(5.0, scheduler: MainScheduler.instance)
                }
                // fade back other labels
                .doOnNext { tick in 
//                    var otherLabels = Array(self.wordsLabels)
//                    otherLabels.removeAtIndex(idx)
//                    otherLabels.forEach { otherLabel in
//                        UIView.animateWithDuration(0.5) {
//                            otherLabel.alpha = 1.0
//                        }
//                    }
                    
                    self.wordsLabels.forEach { otherLabel in
                       
                        UIView.animateWithDuration(0.5) {
                                otherLabel.alpha = 1.0
                        } 
                        
                        
                    }
                }

                .subscribeNext { tick in
                    
                   // print(self.phonemesLabels.count)
                    for pho in 0 ..< self.phonemesLabels.count {
                        
                        print("yess",self.phonemesLabels[pho].text )
                        
                        self.snapBehavior = UISnapBehavior(item: self.phonemesLabels[pho], snapToPoint: CGPointMake(200, 600))
                        self.animator?.addBehavior(self.snapBehavior)
                        
                        //wordText.center
                        
                        //transform
//                        UIView.animateWithDuration(0.3) {
//                            self.phonemesLabels[pho].alpha = 0.0
//                        }
//                        UIView.animateWithDuration(0.8) {
//                            let layer: CALayer = self.phonemesLabels[pho].layer
//                            layer.transform = 
//                                CATransform3D(
//                                    m11: 10, m12: 0, m13: 0, m14: 0, 
//                                    m21: 0, m22: 10, m23: 0, m24: 0, 
//                                    m31: 0, m32: 0, m33: 1, m34: 0, 
//                                    m41: 0, m42: 0, m43: 0, m44: 1)
//                        }
                    }
                }
                .addDisposableTo(disposeBag)
            
            wordText.addGestureRecognizer(pressGesture)
            wordText.userInteractionEnabled = true
            //self.view?.addGestureRecognizer(pressGesture)
        }
    }
    
    func createBox(frame: CGRect, color: UIColor, text: String) -> UILabel {
        
        let newBox = UILabel()
        newBox.frame = frame
        newBox.backgroundColor = color
        newBox.textColor = UIColor.blackColor()
        newBox.textAlignment = .Center        
        newBox.text = text
        newBox.font = newBox.font.fontWithSize(10.0)
        newBox.layer.cornerRadius = 0
        newBox.layer.masksToBounds = true
        
        self.view.addSubview(newBox)
        return newBox
    }
   
    func wordList(word:String) -> [String]
    {
        var wordArr = [String]()
        word.enumerateSubstringsInRange(word.startIndex..<word.endIndex, options: .ByWords) { 
            ss, r, r2, stop in
            wordArr.append(ss!)
        }
        return wordArr
    }
    
}