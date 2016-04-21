//: [Previous](@previous)

import Foundation
import XCPlayground
import RxSwift
import RxCocoa

XCPlaygroundPage.currentPage.needsIndefiniteExecution = true

let ticker = Observable<Int64>.interval(0.25, scheduler: MainScheduler.instance)

ticker
.take(5)
//.subscribeNext { print($0) }

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

}




//timingArray.toObservable()
//.flatMap { delay in 
//    Observable<Int64>
//        .timer(delay, scheduler: MainScheduler.instance)
//        .map { _ in delay }
//}
//.subscribeNext { print($0) }
//


// Chaining Observables
//Observable.just(0.1)
//.flatMap { delay -> Observable<Double> in
//    return Observable<Int64>.timer(delay, scheduler: MainScheduler.instance)
//    .map { _ in print(0.2); return 0.2 } 
//}
//.flatMap { delay -> Observable<Double>in 
//    return Observable<Int64>.timer(delay, scheduler: MainScheduler.instance)
//        .map { _ in print(0.3); return 0.3 } 
//}
//.flatMap { delay -> Observable<Double>in 
//    Observable<Int64>
//        .timer(delay, scheduler: MainScheduler.instance)
//        .map { _ in print(0.4); return 0.4} 
//}
//.flatMap { delay -> Observable<Double>in 
//    Observable<Int64>
//        .timer(delay, scheduler: MainScheduler.instance)
//        .map { _ in print(0.1); return 0.1 } 
//}
//.subscribeNext { evt in print("Finished", evt) }

// Create a sequence of variable timers using `concat` or `flatMap` or `scan` only once.




//: [Next](@next)
