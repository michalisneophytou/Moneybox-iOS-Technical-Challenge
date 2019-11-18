//
//  PostLoginStructs.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 10/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import Foundation


// main object returned from the LogIn POST. Struct is used to decode the JSON return into an object
struct logInObject : Decodable {
    let User: User
    let InformationMessage : String
    let Session : Session
    let ActionMessage : ActionMessage

}

struct User: Decodable{
    let AmlAttempts : Int
    let AmlStatus : String
    let Animal : String
    let CanReinstateMandate : Bool
    let DateCreated : String
    let DirectDebitHasBeenSubmitted : Bool
    let DirectDebitMandateStatus : String
    let DoubleRoundUps : Bool
    let Email : String
    let FirstName : String
    let HasCompletedTutorial : Bool
    let HasVerifiedEmail : Bool
    let IntercomHmac : String
    let IntercomHmacAndroid : String
    let IntercomHmaciOS : String
    let InvestmentTotal : Float
    let InvestorProduct : String
    let IsPinSet : Bool
    let JisaRegistrationStatus : String?
    let JisaRoundUpMode : String
    let LastName : String
    let LastPayment : Date
    let MoneyboxAmount : Float
    let MoneyboxRegistrationStatus : String
    let MonthlyBoostAmount : Float
    let MonthlyBoostDay : Int
    let MonthlyBoostEnabled : Bool
    let PreviousMoneyboxAmount : Float
    let ReferralCode : String
    let RegistrationStatus : String
    let RoundUpMode : String
    let RoundUpWholePounds : Bool
    let UserId : String
}

struct Session: Decodable {
    let BearerToken : String
    let ExpiryInSeconds : Int
    let ExternalSessionId : String
    let SessionExternalId : String
}

struct ActionMessage: Decodable {
    let `Type` : String
    let Message : String
    let Actions : [Action]
}

struct Action: Decodable{
    let Label : String
    let Amount: Float
    let `Type` : String
    let Animation : String
}
    


