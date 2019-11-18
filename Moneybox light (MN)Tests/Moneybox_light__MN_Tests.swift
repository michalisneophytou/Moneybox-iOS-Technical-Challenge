//
//  Moneybox_light__MN_Tests.swift
//  Moneybox light (MN)Tests
//
//  Created by Michalis Neophytou on 02/11/2019.
//  Copyright © 2019 Michalis Neophytou. All rights reserved.
//

import XCTest
@testable import Moneybox_light__MN_

class Moneybox_light__MN_Tests: XCTestCase {

    func testExample() {
        postLogInObject(parameters: ["Email": "email@email.com", "Password": "password", "Idfa": "Anything"] as Dictionary<String, String>, loginCompletionHander: {
            returnedLogInObject, response, error in
            if let urlResponse = response as? HTTPURLResponse{
                XCTAssertEqual(urlResponse.statusCode, 401)            //tests POST function and authentication
            }
        })
    }
}
