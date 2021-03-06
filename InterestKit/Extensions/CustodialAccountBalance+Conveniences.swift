//
//  CustodialAccountBalance+Conveniences.swift
//  InterestKit
//
//  Created by Alex McGregor on 8/6/20.
//  Copyright © 2020 Blockchain Luxembourg S.A. All rights reserved.
//

import PlatformKit

extension CustodialAccountBalance {

    init?(currency: CryptoCurrency,
          response: SavingsAccountBalanceDetails) {
        guard let balance = response.balance else { return nil }
        self = .init(minorValue: balance, currencyType: .crypto(currency))
    }
}

