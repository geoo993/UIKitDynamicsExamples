//: [Previous](@previous)

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCPlayground

let vc = UIViewController()

let disposeBag = DisposeBag()

let textView = UITextView(frame: CGRect(x: 50, y: 200, width: 300, height: 50))
let shadowLayer = CALayer()
let label = UILabel()

let str = "Hi George, Welcome Home"
textView.text = str
textView.font = textView.font?.fontWithSize(22)
textView.editable = false
vc.view.addSubview(textView)

textView.layer.addSublayer(shadowLayer)

let longPressGesture = UILongPressGestureRecognizer()
longPressGesture.minimumPressDuration = 0.0
longPressGesture.rx_event
    .subscribeNext { tap in 
        
        let location = tap.locationInView(textView)
        //let text = tap.view as? UITextView
            
        switch tap.state {
        case .Began: 
            
            
            textView.layoutManager.boundingRectForGlyphRange (NSRange(location: 6, length: 12), inTextContainer: textView.textContainer)
            
            let point = CGPoint(x: 60, y: 5)
            
            let idx = textView.layoutManager.characterIndexForPoint(location, inTextContainer:  textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            let charIdx = str.characters.startIndex.advancedBy(Int(idx))
            print(str.characters[charIdx])

            
            guard let textPosition = textView.closestPositionToPoint(location),
                let wordRange = textView.tokenizer.rangeEnclosingPosition(textPosition, withGranularity: UITextGranularity.Word, inDirection: 0),
                let highlightedText = textView.textInRange(wordRange) else { return }
            
            let rect = textView.firstRectForRange(wordRange)
            //print("word rect", rect, highlightedText)
            
            
            shadowLayer.frame = CGRectMake(rect.origin.x, rect.origin.y-5, rect.size.width, rect.size.height+10)
            shadowLayer.cornerRadius = 5
            shadowLayer.backgroundColor = UIColor.yellowColor().CGColor
            shadowLayer.shadowColor = UIColor.blackColor().CGColor
            shadowLayer.shadowOpacity = 0.6
            shadowLayer.shadowOffset = CGSizeMake(1, 1)
            shadowLayer.shadowRadius = 3
            
            /** Label */
            label.removeFromSuperview()
            let frame = CGRectMake(rect.origin.x, rect.origin.y-5, rect.size.width, rect.size.height+10)
           
            
            label.frame = frame
            label.textColor = UIColor.blackColor()
            label.textAlignment = NSTextAlignment.Center        
            label.text = highlightedText
            label.font = UIFont(name: "Helvetica", size: 20)//newBox.font.fontWithSize(fontSize)
            label.alpha = 0.5
           textView.addSubview(label)
            
            
            
            //                    self.shapesArray.forEach ({ p in
            //                        p.removeFromSuperview()
            //                        self.shapesArray = []
            //                    })
            //                    
            //                    let radius : CGFloat = 50
            //                    let numShapes = 10
            //                    Array(0 ..< numShapes).map { p in 
            //                        
            //                        let Pi = CGFloat(M_PI)
            //                        let DegreesToRadians = Pi / 180
            //                        
            //                        let px = radius * cos(CGFloat(p*(numShapes)) * DegreesToRadians)
            //                        let py = -radius * sin(CGFloat(p*(numShapes)) * DegreesToRadians)
            //                        
            //                        let fr = CGRect(x:bDotX + px, y: 0+py, width: 10, height: 10)
            //                        let uiv = UIView(frame: fr)
            //                        uiv.backgroundColor = UIColor.randomColor()
            //                        uiv.layer.cornerRadius = 4
            //                        uiv.layer.masksToBounds = true
            //                        self.textView.addSubview(uiv)
            //                        
            //                        self.shapesArray.append(uiv)
            //                    }
            
            
            
            //print("began",location)
        case .Changed: 
            print("changed",location)
        case .Ended: 
            print("ended",location)
        default:
            print("tapp ")
        }
    }.addDisposableTo(disposeBag)
textView.addGestureRecognizer(longPressGesture)



textView.tokenizer


XCPlaygroundPage.currentPage.liveView = vc

//: [Next](@next)
