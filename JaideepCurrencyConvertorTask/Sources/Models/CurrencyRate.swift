//
//  CurrencyRate.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation
import SwiftData

@Model
class CurrencyRate: Decodable, Identifiable {
    var id: UUID
    var refreshedTimestamp: Int?
    var baseCurrencyCode: String?
    var rates: [String: Double]?
    var currencies: [Currency]?
    
    enum CodingKeys: String, CodingKey {
        case id
        case refreshedTimestamp = "timestamp"
        case baseCurrencyCode = "base"
        case rates
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = UUID()
        self.refreshedTimestamp = try? container.decodeIfPresent(Int.self, forKey: .refreshedTimestamp)
        self.baseCurrencyCode = try? container.decodeIfPresent(String.self, forKey: .baseCurrencyCode)
        let tempRates = try? container.decodeIfPresent([String: Double].self, forKey: .rates)
        let tempCurrencies = tempRates?.keys.sorted().map { key in
            return Currency(code: key, baseRate: tempRates?[key])
        }
        
        self.rates = tempRates
        self.currencies = tempCurrencies
    }
}
