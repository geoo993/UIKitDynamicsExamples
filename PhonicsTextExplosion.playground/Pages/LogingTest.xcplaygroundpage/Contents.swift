//: [Previous](@previous)

import Foundation
import UIKit
import SpriteKit
import RxSwift
import RxCocoa
import XCPlayground


//let generatedID = Observable.just(Int(arc4random_uniform(100000)))
//
//let createId = generatedID
//    .subscribeNext{ res in
//        print(res)
//      
//    }
//
//func GenerateID(Max: Int) -> Observable<Int> {
//    return Observable.just(Int(arc4random_uniform(UInt32(Max))))
//    
//}
//let id = GenerateID(20000)
//    .subscribe { event in
//        print(event)
//}

struct AutoResponse {
    var userId : String
}
struct UserModel {
    var userName : String
    var funFact : String
    var creditCardProcessoruserId : String
}
struct UserCreditCardAccountResponse {
    var isValid : Bool
    var creditCardIds : [String]
}

struct CreditCardInfo {
    var creditCardId : String
    var expirationTimestamp : NSTimeInterval
}

protocol SampleService {
    
    func rx_login(userName:String, password: String) -> Observable<AutoResponse>
    func rx_getUserInfo(userId:String) -> Observable<AutoResponse>
    func rx_getCreaditCardAccount(userId:String) -> Observable<UserCreditCardAccountResponse>
    func rx_getAllCreditCards(creditCardId:String) -> Observable<[CreditCardInfo]>
}


class UserService {
    
    func GetCreditCards()
    {
        
        let sampleService = [] as! SampleService
        
        sampleService.self.rx_login("max",password: "helllo" )
        .flatMap { (autoResponse) -> Observable<UserCreditCardAccountResponse> in
            return sampleService.rx_getCreaditCardAccount(autoResponse.userId)
        }
        .flatMap { (userCreditCardResponse) -> Observable<[CreditCardInfo]> in
            return sampleService.rx_getAllCreditCards(userCreditCardResponse.creditCardIds[0]) 
        }
        .subscribeNext{ creditCards in
                print(creditCards)
                
        }

    }
}



extension Int {
public static func random(min: Int, max:Int) -> Int {
    return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}


func rx_Buy(stockPulse: Int, accountBalance: Double) -> Observable<Bool> {
    let pricePerUnit : Double = 50.0
    
    return Observable.of(stockPulse)
        .map { orders in
            Double(orders) * pricePerUnit
        }
        .map{ total in
            print("total", total)

            print("accountBalance", accountBalance)
            return total < accountBalance
    }
}



let vc = UIViewController()

var tapResult = Int.random(1, max: 10)
var bal = Int.random(100, max: 300)
var buttons : [UIButton] = []

let walletLabel = UILabel(frame: CGRect(x: 100, y: 40, width: 150, height: 40))
walletLabel.backgroundColor = UIColor.grayColor()
walletLabel.text = "    Wallet:  £ \(Double(bal))"


let textfieldbox = UITextField(frame: CGRect(x: 35, y: 150, width: 300, height: 40))
textfieldbox.backgroundColor = UIColor.whiteColor()


let pressMeButton = UIButton(frame: CGRect(x: 35, y: 200, width: 300, height: 80))
pressMeButton.backgroundColor = UIColor.greenColor()
pressMeButton.setTitle("Press me", forState: UIControlState.Normal)
let subscribeCallback : Event<Void> -> Void = { evt in 
    print(evt, "button tapped = you can buy item ") }
pressMeButton.rx_tap.subscribe(subscribeCallback)

for i in 0...5
{
    let butts = UIButton(frame: CGRect(x: 35 + CGFloat(i % 6) * CGFloat(50), y: 450, width: 40, height: 40))
    butts.setTitle("\(i+1)", forState: UIControlState.Normal)
    butts.backgroundColor = UIColor.brownColor()
    buttons.append(butts)
            
}

//for b in buttons {
//    
//    b.rx_tap
//        .subscribeNext { _ in
//            
//            let ress = Int(b.currentTitle!)!
//            print(ress)
//            
//            rx_Buy(ress,accountBalance: Double(bal))
//                .subscribeNext { (canBuy) -> Void in
//                    pressMeButton.enabled = canBuy
//                    if (canBuy){
//                        pressMeButton.backgroundColor = UIColor.greenColor()
//                    }else{
//                        pressMeButton.backgroundColor = UIColor.redColor()
//                    }
//                    
//            }
//            textfieldbox.rx_text
//            .subscribeNext{ res in
//                    textfieldbox.text = "  Number of Items: \(ress) (Total: £ \(ress * 50))"
//            }
//    }
//    
//    vc.view.addSubview(b)
//}


buttons.forEach { button in
    
    // tapResult transforms the button tap into an Int of the currentTitle
    let tapResult = 
        button
        .rx_tap
        .map { _ in Int(button.currentTitle!)! }
    
    tapResult    
    .flatMap { tapResult -> Observable<Bool> in            
        print(tapResult)
        
        return rx_Buy(tapResult,accountBalance: Double(bal))
            
    }
    // doOnNext allow for side-effects.
    .doOnNext { canBuy in
        pressMeButton.backgroundColor = 
            canBuy ? UIColor.greenColor() : UIColor.redColor()
    }
    // finally bind our rx_Buy observable to button.enabled
    .bindTo(button.rx_enabled)

    tapResult
    .map { result in "  Number of Items: \(result) (Total: £ \(result * 50))" }
    // binds transformed tapResult text to textfieldbox.text
    .bindTo(textfieldbox.rx_text)

    vc.view.addSubview(button)

}
    
vc.view.addSubview(walletLabel)
vc.view.addSubview(textfieldbox)
vc.view.addSubview(pressMeButton)
XCPlaygroundPage.currentPage.liveView = vc


