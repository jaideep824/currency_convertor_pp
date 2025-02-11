//
//  Currency.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation
import SwiftData

struct Currency: Codable, Identifiable, Hashable {
    // MARK: Properties
    var id: String { code }
    let code: String
    let baseRate: Double?
    var convertedRate: Double?
    
    // MARK: Type Properties
    static let example = Currency(code: "USD", baseRate: 1)
    
    // MARK: Initialisations
    init(code: String, baseRate: Double? = 1) {
        self.code = code
        self.baseRate = baseRate
    }
}
