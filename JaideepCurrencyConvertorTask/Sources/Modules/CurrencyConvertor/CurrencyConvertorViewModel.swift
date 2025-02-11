//
//  CurrencyConvertorViewModel.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI
import Foundation

extension CurrencyConvertorView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        // MARK: state variables
        @Published var amount: Double = 0
        @Published var selectedCurrency = Currency(code: Constants.defaultCurrencyCode)
        @Published var currencyRate: CurrencyRate?
        
        // MARK: stored variables
        private let currencyService: CurrencyService
        
        // MARK: - Initialistions
        init(currencyService: CurrencyService) {
            self.currencyService = currencyService
        }
        
        // MARK: - Functions
        // MARK: Get Functions
        func currencyList() -> [Currency] {
            currencyRate?.currencies ?? []
        }
        
        func convertedCurriences() -> [Currency] {
            debugPrint(amount, selectedCurrency)
            
            guard let currencies = currencyRate?.currencies else { return [] }
            let tempCurrencies: [Currency] = currencies.map {
                var currency = Currency(code: $0.code, baseRate: $0.baseRate)
                currency.convertedRate = currencyService.convert(amount, from: selectedCurrency.code, to: $0.code)
                return currency
            }
            
            return tempCurrencies
        }
        
        // MARK: Set Function
        // MARK: Services
        func refreshCurrency() {
            currencyService.fetchRates(baseCurrency: Constants.defaultCurrencyCode) {[weak self] result in
                switch result {
                case .success(let rate):
                    self?.currencyRate = rate
                case .failure(let error):
                    debugPrint("Error fetching rates: \(error)")
                }
            }
        }
    }
}
