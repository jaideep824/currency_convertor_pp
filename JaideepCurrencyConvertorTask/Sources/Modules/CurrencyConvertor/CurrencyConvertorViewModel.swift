//
//  CurrencyConvertorViewModel.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Combine
import Foundation
import SwiftUI

extension CurrencyConvertorView {
    class ViewModel: ObservableObject {
        // MARK: - Properties
        // MARK: state variables
        private var cancellables = Set<AnyCancellable>()
        @Published var amount: String = "0.00"
        @Published var selectedCurrencyCode = Constants.defaultCurrencyCode
        @Published var currencyRate: CurrencyRate?
        @Published var debouncedConvertedCurrencies: [Currency] = []
        
        // MARK: stored variables
        private let currencyService: CurrencyService
        
        // MARK: - Initialistions
        init(currencyService: CurrencyService) {
            self.currencyService = currencyService
            setupDebounce()
        }
        
        // MARK: - Functions
        // MARK: Get Functions
        func currencyList() -> [Currency] {
            currencyRate?.currencies ?? []
        }
        
        func convertedCurriences() -> [Currency] {
            debouncedConvertedCurrencies
        }
        
        func lastSyncTime() -> String? {
            guard let refreshedTimestamp = currencyRate?.refreshedTimestamp else {
                return nil
            }
            
            return Date(timeIntervalSince1970: TimeInterval(refreshedTimestamp)).toString()
        }
        
        func forceRefreshDataFromRemote() {
            refreshCurrency(forceReload: true)
        }
        
        // MARK: Set Function
        // MARK: Services
        func refreshCurrency(forceReload: Bool = false) {
            currencyService.fetchRates(baseCurrency: Constants.defaultCurrencyCode, forceReload: forceReload) {[weak self] result in
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

private extension CurrencyConvertorView.ViewModel {
    func convertCurriences(amount: String, from: String) -> [Currency] {
        guard let amountDoubleValue = Double(amount) else { return [] }
        guard let currencies = currencyRate?.currencies else { return [] }
        
        let tempCurrencies: [Currency] = currencies.map {
            var currency = Currency(code: $0.code, baseRate: $0.baseRate)
            currency.convertedRate = currencyService.convert(amountDoubleValue, from: selectedCurrencyCode, to: $0.code)
            return currency
        }
        
        return tempCurrencies
    }
    
    func setupDebounce() {
        Publishers.CombineLatest($amount, $selectedCurrencyCode)
            .debounce(for: .seconds(0.5), scheduler: RunLoop.main)
            .sink { [weak self] _ in
                guard let `self` = self else { return }
                self.debouncedConvertedCurrencies = self.convertCurriences(amount: self.amount, from: self.selectedCurrencyCode)
            }
            .store(in: &cancellables)
    }
}
