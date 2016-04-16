//: [Previous](@previous)

import Foundation
import UIKit
import SpriteKit
import RxSwift
import RxCocoa


var chosenLetter = [String: [String]]()
chosenLetter["a"] = ["AO","AA","AX","AE","AH"]
chosenLetter["e"] = ["EH","IY"]
chosenLetter["i"] = ["IY","IH"]
chosenLetter["o"] = ["AO","AA"]
chosenLetter["u"] = ["UW","UH","AH","AX"]
chosenLetter["b"] = ["B"]
chosenLetter["c"] = ["K", "S"]
chosenLetter["d"] = ["D","DH"]
chosenLetter["f"] = ["F"]
chosenLetter["g"] = ["G"]
chosenLetter["h"] = ["HH"]
chosenLetter["j"] = ["JH"]
chosenLetter["k"] = ["K"]
chosenLetter["l"] = ["L"]
chosenLetter["m"] = ["M"]
chosenLetter["n"] = ["N"]
chosenLetter["p"] = ["P"]
chosenLetter["q"] = ["K"]
chosenLetter["r"] = ["R"]
chosenLetter["s"] = ["S"]
chosenLetter["t"] = ["T"]
chosenLetter["v"] = ["V"]
chosenLetter["w"] = ["W"]
chosenLetter["x"] = ["Z"]
chosenLetter["y"] = ["Y"]
chosenLetter["z"] = ["Z"]

let ww = "hello"
let letters = ww.characters
    .map { letter -> String in

    return String(letter)
}
    .map { letter in
        return chosenLetter[letter]
}

letters.forEach { ll in
    print(ll?[0],ll?.count)
}

let res = letters
    .map { letter -> String in
        //print(letter)
        return String(letter)
}

//print(res)




let min = 40 
let max = 400

let amount = 5

let offset = (max - min) / amount

let ress0 = min + (offset * 0)
let ress1 = min + (offset * 1)
let ress2 = min + (offset * 2)
let ress3 = min + (offset * 3)
let ress4 = min + (offset * 4)



func checkCharSet(part:String, cSet:NSCharacterSet) -> Bool{
    let check = part.rangeOfCharacterFromSet(cSet)
    return (check != nil) ? true : false
}

func isPunctuation(part:String) -> Bool{
    let punctSet = NSCharacterSet.punctuationCharacterSet()
    return checkCharSet(part, cSet: punctSet)
}    

func isHexadecimal(part:String) -> Bool{
    let hexadecimal = NSCharacterSet.alphanumericCharacterSet()
    return checkCharSet(part, cSet: hexadecimal)
}




var arr = [String]()
var part:String = ""


let word = "Biff got the eggs. She put them in the box"

word.enumerateSubstringsInRange(word.startIndex..<word.endIndex, options: .ByComposedCharacterSequences) { (
    ss, r, r2, stop) -> () in
    
    
    if isHexadecimal(ss!){
        part += ss!
    }else{
        arr.append(part)
        arr.append(ss!)
        part = ""
    }
}

let wordsOnly = arr.filter({isHexadecimal($0)})
let punctOnly = arr.filter({isPunctuation($0)})

print("\(arr)")
print("\(wordsOnly)")
print("\(punctOnly)")

