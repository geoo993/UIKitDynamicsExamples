//: [Previous](@previous)

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCPlayground

let vc = UIViewController()

let disposeBag = DisposeBag()

let textView = UITextView(frame: CGRect(x: 0, y: 0, width: 300, height: 100))

let str = "Hello George"
textView.text = str
textView.font = textView.font?.fontWithSize(30)
textView.editable = false
vc.view.addSubview(textView)

let longPressGesture = UILongPressGestureRecognizer()
longPressGesture.minimumPressDuration = 0.0
longPressGesture.rx_event
    .subscribeNext { tap in 
        
        let location = tap.locationInView(vc.view)
        //let button = tap.view as! UIButton 
        switch tap.state {
        case .Began: 
            
            textView.layoutManager.boundingRectForGlyphRange (NSRange(location: 6, length: 12), inTextContainer: textView.textContainer)
            
            let point = CGPoint(x: 60, y: 5)
            
            let idx = textView.layoutManager.characterIndexForPoint(location, inTextContainer:  textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
            
            let charIdx = str.characters.startIndex.advancedBy(Int(idx))
            print(str.characters[charIdx])

            
            print("began",location)
        case .Changed: 
            print("changed",location)
        case .Ended: 
            print("ended",location)
        default:
            print("tapp ")
        }
    }.addDisposableTo(disposeBag)
vc.view.addGestureRecognizer(longPressGesture)

textView.tokenizer


XCPlaygroundPage.currentPage.liveView = vc

//: [Next](@next)
