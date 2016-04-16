//: Playground - noun: a place where people can play



import Foundation
import UIKit
import RxSwift
import RxCocoa
import XCPlayground

//part 1
let a = [0,1,2,3,4,5]
print(a)

let b = [1, 2, 3, 4, 5, 6]
    .filter{ $0 % 2 == 0 }
print(b)

let c = [1, 2, 3, 4, 5, 6]
    .map{ $0 * 5 }
print(c)
print("today")

let d = [1, 2, 3, 4, 5, 6]
    .reduce(0, combine: +)
print(d)

let optionalInts: [Int?] = [1, 2, nil, 4, nil, 5]
let e = optionalInts.flatMap { $0 }
print(e)

let nestedArrayInts = [[1,2,3], [4,5,6]]
let f = nestedArrayInts
    .flatMap { array in
    array.map { element in
        element * 2 
    }
}
print(f) 



//part 2
let setOfInts = Set([1,2,3,4,5,4,3,2,1,0,6])
let aa = setOfInts.toObservable()
    .takeLast(4)
    .doOnCompleted({ 
        print("completed aa")
    })
    .subscribeNext { num in
        print(num)
}

let bb = [1, 2, 3, 4, 5, 6].toObservable()
    .filter{ $0 % 2 == 0 }
    .doOnCompleted({ 
        print("completed bb")
    })
    .subscribeNext { 
        print($0) 
}

let cc = Observable.of(0, 1, 2, 3, 4, 5)
    .map { $0 + 3 }
    .doOnCompleted({ 
        print("completed cc")
    })
    .subscribeNext { 
            print($0) 
}


let dd = [0, 1, 2, 3, 4, 5, 6, 8, 7, 8, 9].toObservable()
    .reduce(0, accumulator: +)
    .doOnCompleted({ 
        print("completed dd")
    })
    .subscribeNext { 
        print($0) 
}
let ddd = [[0, 1, 2, 3, 4, 5], [6, 8, 7, 8, 9]].toObservable()
    .flatMap { res -> Observable<Int> in
        return res.toObservable()
            .reduce(0, accumulator: +)
    }
    .doOnCompleted({ 
        print("completed ddd")
    })
    .subscribeNext { 
        print($0) 
}
let dds = [0, 1, 2, 3, 4, 5, 6, 8, 7, 8, 9].toObservable()
    .scan(0, accumulator: { acum, elem in
        acum + elem})
    .doOnCompleted({ 
        print("completed dds")
    })
    .subscribeNext { 
        print($0) 
}




let ee = [[1, 2, 3, 4, 5],[0,2,3,4,5]].toObservable()
  
    .flatMap { res -> Observable<Int> in
        return res.toObservable()
    }
    .doOnCompleted({ 
        print("completed ee")
    })
    .subscribeNext { 
        print($0) 
}

let ff = [[1, 2, 3, 4, 5],[0,2,3,4,5]].toObservable()
    
    .flatMap { res -> Observable<Int> in
        return res.toObservable()
            .map { element in
                element * 2 
        }
    }
    .doOnCompleted({ 
        print("completed ff")
    })
    .subscribeNext { 
        print($0) 
}




let sequenceInt = Observable.of(1, 2, 3)
let sequenceString = ["A", "B", "C", "D", "E", "F"].toObservable()
//let sequenceString = Observable.of("A", "B", "C", "D", "E", "F", "--")
sequenceInt
    .flatMap { (x:Int) -> Observable<String> in
        print("Int from sequenceInt \(x)")
        return sequenceString
    }
    .subscribeNext { str in
        print(str)
}

let arr = [1,2,3,4,5,6]
    .toObservable()
    .subscribe(onNext: { (intValue) -> Void in
        // Pumped out an int
            print(intValue)
        }, onError: { (error) -> Void in
            // ERROR!
            print(error)
            NopDisposable.instance
        }, onCompleted: { () -> Void in
            // There are no more signals
    }) { () -> Void in
        // We disposed this subscription
}

