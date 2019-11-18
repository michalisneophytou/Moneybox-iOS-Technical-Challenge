//
//  detailToOverviewProtocol.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 16/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import Foundation

protocol detailToOverviewProtocol {
    func oneOffPaymentComplete(investorProductID : Int, newAmount: Int)
    func getToken() -> String
}
