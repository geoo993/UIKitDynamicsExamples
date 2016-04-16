//: [Previous](@previous)

import Foundation


class SomeClass {
    var name: String
    init(name: String) {
        self.name = name
    }
}

var aClass = SomeClass(name: "Bob")
var bClass = aClass // aClass and bClass now reference the same instance!
bClass.name = "Sue"

print(aClass.name) // "Sue"
print(bClass.name) // "Sue"


struct SomeStruct {
    var name: String
    init(name: String) {
        self.name = name
    }
}

var aStruct = SomeStruct(name: "Bob")
var bStruct = aStruct // aStruct and bStruct are two structs with the same value!
bStruct.name = "Sue"

print(aStruct.name) // "Bob"
print(bStruct.name) // "Sue"


//a class is awesome. But for values that are simply a measurement or bits of related data, a struct makes more sense so that you can easily copy them around and calculate with them or modify the values without fear of side effects.