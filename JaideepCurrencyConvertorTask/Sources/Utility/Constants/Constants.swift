//
//  Constants.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation

struct Constants {
    // MARK: Constants
    static let defaultCurrencyCode = "USD"
    static let rateRefreshDurationInSec: Double = 1800
    
    // MARK: Computed
    static var currencyFormatIdentifier: String {
        NSLocale.current.currency?.identifier ?? Constants.defaultCurrencyCode
    }
}
