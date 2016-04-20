//
//  WordModel.swift
//  UIKitDynamicsApp
//
//  Created by GEORGE QUENTIN on 13/04/2016.
//  Copyright © 2016 RealEx. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

extension String {
    
    
    public static func randomVowels(excludedVowelsCharacter: Character? = nil) -> String {
        
        let vowels = "aeiou"
        let filtered = String(vowels
            .characters
            .filter { char in char != excludedVowelsCharacter }
        )
        
        let allowedVowelsCount = filtered.characters.count
        let randomNum = Int.random(0, max: allowedVowelsCount-1) 
        let randomVowel = String(filtered[filtered.startIndex.advancedBy(randomNum)])
        
        return  randomVowel
        
    }
    
    public static func randomConsonants(excludedConsonantCharacter: Character? = nil) -> String {
        
        let consonants = "bcdfghjklmnpqrstvwxyz"
        let filtered = String(consonants
            .characters
            .filter { char in char != excludedConsonantCharacter }
        )
        
        let allowedConsonantsCount = filtered.characters.count
        let randomNum = Int.random(0,max:allowedConsonantsCount-1)
        let randomConsonant = String(filtered[filtered.startIndex.advancedBy(randomNum)])
        
        return randomConsonant
    }
    
    func words() -> [String] {
        
        let range = Range<String.Index>(start: self.startIndex, end: self.endIndex)
        var words = [String]()
        
        self.enumerateSubstringsInRange(range, options: NSStringEnumerationOptions.ByWords) { (substring, _, _, _) -> () in
            words.append(substring!)
        }
        
        return words
    }
}


class WordModel {
    
    var patternsArray = [["A","M","S"],["S","M","S"],["A","M","A"],["S","M","S"]]
    
    var arpabet = [String: [String]]()
    var letters = [String: [String]]()
    var chosenLetter = [String: [String]]()
    
    
    
    func getPho() {
        
        //ChosenLetters
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
        
    }
    
    func getPatt() -> String {
  
        //VVVVVVV
        //Monophthongs
        arpabet["M"] = ["AO","AA","IY","UW","EH","IH","UH","AH","AX","AE"]
        letters["AO"] = ["o","a"]
        letters["AA"] = ["a","o"]
        letters["IY"] = ["ee","e","i"]
        letters["UW"] = ["u","ou","ew","oo"]
        letters["EH"] = ["e"]
        letters["IH"] = ["i"]
        letters["UH"] = ["u","ou"]
        letters["AH"] = ["u","a"]
        letters["AX"] = ["a","u"]
        letters["AE"] = ["a"]
        
        
        //CCCCCCCC
        //Stops
        arpabet["S"] = ["P","B","T","D","K","G"]
        letters["P"] = ["p"]
        letters["B"] = ["b"]
        letters["T"] = ["t"]
        letters["D"] = ["d"]
        letters["K"] = ["k"]
        letters["G"] = ["g"]
        
        //Affricates
        arpabet["A"] = ["CH","JH"]
        letters["CH"] = ["ch"]
        letters["JH"] = ["j"]
        
        
        let pattern1 = Int.random(0, max: (patternsArray.count)-1)
        let pat1 = patternsArray[pattern1][0]
        let pat2 = patternsArray[pattern1][1]
        let pat3 = patternsArray[pattern1][2]
        
        let searchFirst = Int.random(0, max: (arpabet[pat1]!.count)-1) 
        let searchSecond = Int.random(0, max: (arpabet[pat2]!.count)-1)
        let searchThird = Int.random(0, max: (arpabet[pat3]!.count)-1) 
        
        let first = arpabet[pat1]![searchFirst]
        let second = arpabet[pat2]![searchSecond]
        let third = arpabet[pat3]![searchThird]
        
        let word1 = letters[first]![Int.random(0, max:(letters[first]!.count)-1)] 
        let word2 = letters[second]![Int.random(0, max:(letters[second]!.count)-1)] 
        let word3 = letters[third]![Int.random(0, max:(letters[third]!.count)-1)]  
        
        let fullWord = "\(word1)\(word2)\(word3)"
        //print(fullWord)
        return fullWord
    }
    
    
//    func gePhonemes(word: String) -> [[String]?]
//    {
//        let letters = word.characters
//        .map { letter -> String in
//            return String(letter)
//        }
//        .map { letter in
//            return chosenLetter[letter]
//        }
//        
////        .map { letter -> String in
////            return String(letter)
////        }
//
////        letters.forEach { ll in
////            print(ll?[0],ll?.count)
////        }
//        return letters
//    }

}