//
//  ExchangeRatesTests.swift
//  BlockchainTests
//
//  Created by Jack on 01/07/2019.
//  Copyright © 2019 Blockchain Luxembourg S.A. All rights reserved.
//

@testable import Blockchain
import BigInt
import ERC20Kit
import PlatformKit
import XCTest

class ExchangeRatesTests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_convert() {
        let balanceString = "16.64306683"
        let balanceCrypto = CryptoValue.create(major: balanceString, currency: .pax)!
        let rates: ExchangeRates = Fixtures.load(name: "rates", in: Bundle(for: ExchangeRatesTests.self))!
        let conversion: FiatValue = rates.convert(balance: balanceCrypto, toCurrency: FiatCurrency.CAD)
        XCTAssertEqual(conversion.toDisplayString(includeSymbol: false), "21.80")
    }
}
