//: [Previous](@previous)

import Foundation
import RxSwift
import RxCocoa

//creating sequences and subscribe
//subscribenext takes next element but subscibe takes next, complete, and error
//observable type: ticker, map, flatmap, combine, filter, distinct until change  throttle ........
//subcribe always come last after all the tranformation given to a subscription
//observable sequences can be created using arrays, dictionairies, list , sets etc... 
//you can create observable sequences by simply adding -toObservable() - next to any sequence i.e array, set , dictionary etc...
//filter always takes a closure i.e {}, its argumenet is based on the element of the sequence (i.e. string, int). the filter takes the element of the sequence and retuns a bool based on the argument of the filter
//map mainly transforms elements
//flatmap does the tranformation of observables sequences
// DoOn, DoOnNext and SubscribeNext are side effect function, were to want to pass on instructions
