//
//  detailToOverviewProtocol.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 16/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import Foundation

//protocol used for detail view AccountDetailController to pass data and trigger functions of its parent view AccountViewController
protocol detailToOverviewProtocol {
    func oneOffPaymentComplete(investorProductID : Int, newAmount: Int)
    func getToken() -> String
}
