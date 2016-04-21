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

var tickOffset = 1

let timingArray = [0.1, 0.3, 0.5, 1.8, 1.0, 4.8, 0.6, 2.4, 0.2]

let scanning = timingArray.toObservable()
    .scan(0, accumulator: { acum, elem in
        acum + elem})
    .flatMap { delay in 
        Observable<Int64>
            .timer(delay, scheduler: MainScheduler.instance)
            .map { _ in delay }
    }
    .subscribeNext { tick in 
        print(tick) 
        
        tickOffset += 1
        
        let newBox = UILabel(frame: CGRect(x: (30 * tickOffset), y: 200, width: 40, height: 40))
            newBox.backgroundColor = UIColor.redColor()
            newBox.layer.cornerRadius = 2
            newBox.layer.borderColor
            newBox.layer.borderWidth = 5
            newBox.layer.masksToBounds = true
            
            vc.view.addSubview(newBox)
        
}




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
