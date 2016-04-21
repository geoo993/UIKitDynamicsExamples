//: [Previous](@previous)

import Foundation
import UIKit
import XCPlayground
import RxSwift
import RxCocoa

let vc = UIViewController()

let button = UIButton(frame: CGRect(x: 10, y: 10, width: 200, height: 100))
//button.backgroundColor = UIColor.redColor()
button.setTitle("Press me!", forState: UIControlState.Normal)
button.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)

vc.view.addSubview(button)

var state = false
//let subscription =
//    button.rx_tap
//    .subscribeNext{ 
//        state = !state
//        button.backgroundColor = state ? UIColor.redColor() : UIColor.greenColor() 
//        print(state)
//}

//Observable<Int64>.interval(5.0, scheduler: MainScheduler.instance)
//    .take(1)
//    .subscribeNext { tick in subscription.dispose() }


//
//Observable<Int64>.interval(0.5, scheduler: MainScheduler.instance)
//    .subscribeNext { tick in state = (tick % 2 == 0) }

let mySwitcher = 
    button.rx_tap
    .scan(false) { acc, x in return !acc }
    .doOnNext { button.backgroundColor = $0 ? UIColor.redColor() : UIColor.greenColor()  }
    .map { $0 ? "on" : "off" }
    .subscribeNext { print($0) }




XCPlaygroundPage.currentPage.liveView = vc

print("Finished")

//: [Next](@next)
