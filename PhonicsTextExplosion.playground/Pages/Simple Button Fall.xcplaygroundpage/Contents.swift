//: [Previous](@previous)

import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCPlayground

let vc = UIViewController()

//generate sequence by generating numbers of in for loop style
let generated = Observable.generate(
    initialState: 0,///start at
    condition: { $0 < 4 }, //if statement
    iterate: { $0 + 2 } //for loop
)

let subscription2 = generated
    //.elementAt(3)
    .subscribeNext { event in
        print(event)
    let b = UIButton(frame: CGRect(x: event + 5, y: 0, width: 50, height: 150))
        b.backgroundColor = UIColor.redColor()
        vc.view.addSubview(b)
}


let square = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
square.backgroundColor = UIColor.grayColor()
vc.view.addSubview(square)

let button = UIButton(frame: CGRect(x: 100, y: 300, width: 100, height: 100))
button.setTitle("Push me", forState: UIControlState.Normal)
button.backgroundColor = UIColor.grayColor()
vc.view.addSubview(button)

let animator = UIDynamicAnimator(referenceView: vc.view)
let gravity = UIGravityBehavior(items: [button])

button.rx_tap
    .subscribeNext {
        animator.addBehavior(gravity)
}

//print(gravity)

XCPlaygroundPage.currentPage.liveView = vc
//: [Next](@next)
