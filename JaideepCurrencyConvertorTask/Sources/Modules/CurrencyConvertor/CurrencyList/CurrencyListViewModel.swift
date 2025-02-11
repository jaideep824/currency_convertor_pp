//
//  Currency.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

extension CurrencyListView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        private let curriencies: [Currency]
        
        // MARK: - Initialistions
        init(curriencies: [Currency]) {
            self.curriencies = curriencies
        }
        
        // MARK: - Functions
        // MARK: Get Functions
        func currencyList() -> [Currency] {
            curriencies
        }
        
        func formattedCurrencyRate(for currency: Currency) -> String {
            if let convertedRate = currency.convertedRate {
                return String(format: "%.2f", convertedRate)
            }
            return ""
        }
    }
}
