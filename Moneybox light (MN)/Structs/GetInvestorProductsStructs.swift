//
//  GetInvestorProductsStructs.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 12/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import Foundation

// main object returned from GET investorproducts. Struct is used to decode the JSON reponse into an object
struct investorProductsObject: Decodable {
    let MoneyboxEndOfTaxYear: String
    let TotalPlanValue: Double
    let TotalEarnings: Double
    let TotalContributionsNet: Double
    let TotalEarningsAsPercentage: Double
    var ProductResponses: [ProductResponse]
}

struct ProductResponse: Decodable {
    let Id: Int
    let PlanValue: Double
    var Moneybox: Int
    let SubscriptionAmount: Int
    let TotalFees: Double
    let IsSelected: Bool
    let IsFavourite: Bool
    let Contributions: Contributions
    let Product: Product
    let InvestorAccount: InvestorAccount
    let Personalisation: Personalisation
    let CollectionDayMessage: String
}

struct Contributions: Decodable {
    let IsAvailable: Bool
    let Status: String
}

struct InvestorAccount: Decodable {
    let ContributionsNet: Int
    let EarningsNet: Double
    let EarningsAsPercentage: Double
}

struct Personalisation: Decodable {
    let QuickAddDeposit: QuickAddDeposit
    let HideAccounts: HideAccounts
}

struct HideAccounts: Codable {
    let Enabled: Bool
    let IsHidden: Bool
    let Sequence: Int
}

struct QuickAddDeposit: Decodable {
    let Amount: Int
}

struct Product: Decodable {
    let Id: Int
    let Name: String
    let CategoryType: String
    let `Type`: String
    let FriendlyName: String
    let CanWithdraw: Bool
    let ProductHexCode: String
    let AnnualLimit: Int
    let DepositLimit: Int
    let Lisa: Lisa?
}

struct Lisa: Codable {
    let MaximumBonus: Int
}
