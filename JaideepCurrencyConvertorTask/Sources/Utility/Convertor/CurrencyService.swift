//
//  CurrencyService.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Combine
import Foundation

class CurrencyService {
    // MARK: Variables
    private var cancellables = Set<AnyCancellable>()
    private var currencyRate: CurrencyRate?
    
    // MARK: -  Exposed Functions
    func fetchRates(baseCurrency: String, completion: @escaping (Result<CurrencyRate, Error>) -> Void) {
        if let savedRates = fetchSavedRates(baseCurrency: baseCurrency), !isRatesExpired(timestamp: savedRates.refreshedTimestamp) {
            completion(.success(savedRates))
        } else {
            fetchRatesFromAPI(baseCurrency: baseCurrency) {[weak self] result in
                switch result {
                case .success(let newRates):
                    // TODO: Save reates
                    self?.currencyRate = newRates
                    completion(.success(newRates))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
   
    // MARK: Convertor
    func baseRate(for currency: String) -> Double? {
        return currencyRate?.rates?[currency]
    }
    
    func amountInBaseCurrency(_ amount: Double, sourceCurrency: String) -> Double? {
        if let sourceRate = currencyRate?.rates?[sourceCurrency] {
            let amountInBaseCurrency = amount / sourceRate
            return amountInBaseCurrency
        }
        return nil
    }
    
    func convert(_ amount: Double, from sourceCurrency: String?, to targetCurrency: String?) -> Double? {
        guard let sourceCurrency else { return nil }
        guard let targetCurrency else { return nil }
        
        if sourceCurrency == currencyRate?.baseCurrencyCode {
            return convertFromBaseCurrency(amount, to: targetCurrency)
        }
        
        guard let amountInBaseCurrency = amountInBaseCurrency(amount, sourceCurrency: sourceCurrency) else {
            return nil
        }
        
        guard let targetRate = baseRate(for: targetCurrency) else {
            return nil
        }
        
        return amountInBaseCurrency * targetRate
    }
    
    func convertFromBaseCurrency(_ amount: Double, to targetCurrencyCode: String) -> Double? {
        if let targetRate = currencyRate?.rates?[targetCurrencyCode] {
            return amount * targetRate
        }
        debugPrint("Error: Invalid target currency code.")
        return nil
    }
}

private extension CurrencyService {
    func isRatesExpired(timestamp: Int?) -> Bool {
        guard let timestamp else { return true }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date.addingTimeInterval(Constants.rateRefreshDurationInSec) < Date()
    }
    
    func fetchSavedRates(baseCurrency: String) -> CurrencyRate? {
        return nil
    }
    
    func fetchRatesFromAPI(baseCurrency: String, completionHandler: @escaping (Result<CurrencyRate, NetworkError>) -> Void) {
        let apiConfig = NetworkConfig(endPoint: .currencyRates)
        let params = ["app_id": APIKeys.openExchange,
                      "base": Constants.defaultCurrencyCode]
        
        let response: Future<CurrencyRate, NetworkError> = Networking.shared.fetchData(with: apiConfig, andParams: params)
        response
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    completionHandler(.failure(error))
                case .finished:
                    debugPrint("Finished successfully.")
                }
            } receiveValue: { rates in
                completionHandler(.success(rates))
            }
            .store(in: &cancellables)
    }
}
