//
//  TextviewViewController.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 17/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class TextviewViewController: UIViewController {
    
    let disposeBag = DisposeBag()
    var fontsize : CGFloat = 20
    var words : [String] = ["Hi","George","Welcome","Home"]
    
    var lbl = UILabel()
    var shadowLayer: CALayer = CALayer()
    
    let startX : CGFloat = 10
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("text view")
        self.view.backgroundColor = UIColor.randomColor()
        
        let textView = UITextView(frame: CGRect(x: startX, y: 200, width: 300, height: 50))
        let str = "Hi George, Welcome Home"
        textView.text = str
        textView.font = textView.font?.fontWithSize(fontsize)
        textView.editable = false
        self.view.addSubview(textView)
        
        
        
        let t = UITextView(frame: CGRect(x: startX, y: 400, width: 300, height: 50))
        t.text = str
        t.font = t.font?.fontWithSize(fontsize)
        t.editable = false
        self.view.addSubview(t)
        
        
        
       
        let longPressGesture = UILongPressGestureRecognizer()
        longPressGesture.minimumPressDuration = 0.0
        
        longPressGesture.rx_event
            .subscribeNext { tap in 
                
                let location = tap.locationInView(t)
                //let text = tap.view as? UITextView
                
                switch tap.state {
                case .Began: 
                    
                    self.searchData(self.words[Int.random(0, max: self.words.count-1)], textview: t)
                    
                    ////part 2
//                    let layoutManager = text!.layoutManager
//                    
//                    location.x -= text!.textContainerInset.left
//                    location.y -= text!.textContainerInset.top
//                    
//                    // character index at tap location
//                    let characterIndex = layoutManager.characterIndexForPoint(location, inTextContainer: text!.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//                    
//                    print(characterIndex)
//                    
//                     //if index is valid then do something.
//                    if characterIndex < text!.textStorage.length {
//                        
//                        // print the character index
//                        print("character index: \(characterIndex)")
//                        
//                        // print the character at the index
//                        let myRange = NSRange(location: characterIndex, length: 1)
//                        let substring = (text!.attributedText.string as NSString).substringWithRange(myRange)
//                        print("character at index: \(substring)")
//                        
//                        // check if the tap location has a certain attribute
//                        let attributeName = "MyCustomAttributeName"
//                        let attributeValue = text!.attributedText.attribute(attributeName, atIndex: characterIndex, effectiveRange: nil) as? String
//                        if let value = attributeValue {
//                            print("You tapped on \(attributeName) and the value is: \(value)")
//                        }
//                        
//                    }
                    
                    ////part1
//                    self.textView.layoutManager.boundingRectForGlyphRange (NSRange(location: 6, length: 12), inTextContainer: self.textView.textContainer)
//                    
//                    //let point = CGPoint(x: 60, y: 5)
//                    
//                    let idx = self.textView.layoutManager.characterIndexForPoint(location, inTextContainer:  self.textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
//                    
//                    let charIdx = str.characters.startIndex.advancedBy(Int(idx))
//                    print(charIdx, str.characters[charIdx])
//                    
                    
                print("began",location)
                case .Changed: 
                    print("changed",location)
                case .Ended: 
                    print("ended",location)
                default:
                    print("tapp ")
                }
            }.addDisposableTo(disposeBag)
        t.addGestureRecognizer(longPressGesture)
    }
        


    
    func searchData(highlightWord: String, textview: UITextView)
    {
        do {
            
            
            //let error: NSError? = nil
            let pattern: String = highlightWord
            // pattern to search thee data either regular expression or word.
            
            let string: String = textview.text
            let str = textview.textStorage.length
            let range: NSRange = NSMakeRange(0, str)
           
            let regex = try NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive)
            
            let matches: [AnyObject] = regex.matchesInString(string, options: [], range: range)
            
            self.highlightMatches(matches,inTextView: textview)
            
        }catch {
            print(error)
            // Handling error
        }
        
       
    }
    
    func highlightMatches(matches: NSArray,inTextView: UITextView )
    {
        
        //textview.layer.removeFromSuperlayer()
        //textview.layer.removeAllAnimations()
        //matches.reverseObjectEnumerator()
        
        let mutableAttributedString: NSMutableAttributedString = inTextView.attributedText.mutableCopy() as! NSMutableAttributedString
        
        matches.enumerateObjectsUsingBlock({ obj, idx, stop in
            //your code
            
            if obj.isKindOfClass(NSTextCheckingResult.self) {
             
                let match: NSTextCheckingResult = (obj as? NSTextCheckingResult)!
                let rect: CGRect = self.frameOfTextRange(match.range, inTextView: inTextView)
                
                /** Shadow */
                self.shadowLayer.removeFromSuperlayer()
                self.shadowLayer.frame = CGRectMake(rect.origin.x, rect.origin.y-5, rect.size.width, rect.size.height+10)
                self.shadowLayer.cornerRadius = 5
                self.shadowLayer.backgroundColor = UIColor.yellowColor().CGColor
                self.shadowLayer.shadowColor = UIColor.blackColor().CGColor
                self.shadowLayer.shadowOpacity = 0.6
                self.shadowLayer.shadowOffset = CGSizeMake(1, 1)
                self.shadowLayer.shadowRadius = 3
                
                /** Label */
                self.lbl.removeFromSuperview()
                self.lbl = UILabel(frame: CGRectMake(rect.origin.x, rect.origin.y-5, rect.size.width, rect.size.height+10))
                self.lbl.font = UIFont(name: "Helvetica", size: self.fontsize-5)
                self.lbl.textColor = UIColor.blackColor()
                self.lbl.text = mutableAttributedString.attributedSubstringFromRange(match.range).string
                self.lbl.backgroundColor = UIColor.clearColor()
                self.lbl.textAlignment = NSTextAlignment.Center
                self.lbl.layer.cornerRadius = 10
                
                inTextView.layer.addSublayer(self.shadowLayer)
                inTextView.addSubview(self.lbl)
            }

        })
      
        
    }

    func frameOfTextRange(range:NSRange, inTextView:UITextView) -> CGRect
    {
        let beginning: UITextPosition = inTextView.beginningOfDocument
        //Error=: request for member 'beginningOfDocument' in something not a structure or union
        let start: UITextPosition = inTextView.positionFromPosition(beginning, offset: range.location)!
        let end: UITextPosition = inTextView.positionFromPosition(start, offset: range.length)!
        let textRange: UITextRange = inTextView.textRangeFromPosition(start, toPosition: end)!
        let rect: CGRect = inTextView.firstRectForRange(textRange)
        
        //Error: Invalid Intializer
        return inTextView.convertRect(rect, fromView: inTextView.textInputView)
        // Error: request for member 'textInputView' in something not a structure or union

    
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