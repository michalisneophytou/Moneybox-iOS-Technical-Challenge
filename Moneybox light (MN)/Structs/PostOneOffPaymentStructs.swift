//
//  OneOffPaymentStructs.swift
//  Moneybox light (MN)
//
//  Created by Michalis Neophytou on 16/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import Foundation
// This is used to decode the JSON return into an object from the POST for one-off payments

struct oneOffPaymentObject: Decodable {
        let Moneybox: Int
}
