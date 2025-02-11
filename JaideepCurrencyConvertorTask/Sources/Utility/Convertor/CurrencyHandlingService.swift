//
//  CurrencyService.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Combine
import Foundation
import SwiftData

class CurrencyHandlingService {
    // MARK: Variables
    private let modelContext: ModelContext
    private var cancellables = Set<AnyCancellable>()
    private var currencyRate: CurrencyRateData?
    
    // MARK: Initialisation
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    // MARK: -  Exposed Functions
    func fetchRates(baseCurrency: String, forceReload: Bool = false, completion: @escaping (Result<CurrencyRateData, Error>) -> Void) {
        if let savedRates = fetchSavedRates(baseCurrency: baseCurrency), !isRatesExpired(timestamp: savedRates.refreshedTimestamp), forceReload == false {
            self.currencyRate = savedRates
            completion(.success(savedRates))
        } else {
            fetchRatesFromAPI(baseCurrency: baseCurrency) {[weak self] result in
                switch result {
                case .success(let newRates):
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
    
    func isRatesExpired(timestamp: Int?) -> Bool {
        guard let timestamp else { return true }
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        return date.addingTimeInterval(Constants.rateRefreshDurationInSec) < Date()
    }
    
    func fetchSavedRates(baseCurrency: String) -> CurrencyRateData? {
        let descriptor = FetchDescriptor<CurrencyRateData>(sortBy: [SortDescriptor(\.refreshedTimestamp, order: .reverse)])
        
        do {
            let results = try modelContext.fetch(descriptor)
            return results.first
        } catch {
            debugPrint("Failed to fetch: \(error)")
            return nil
        }
    }
    
    func saveFetchedRates(currencyRate: CurrencyRateData?) async {
        guard let currencyRate else { return }
        
        await MainActor.run {
            modelContext.insert(currencyRate)
            do {
                try modelContext.save()
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    func fetchRatesFromAPI(baseCurrency: String, completionHandler: @escaping (Result<CurrencyRateData, NetworkError>) -> Void) {
        let apiConfig = NetworkConfig(endPoint: .currencyRates)
        let params = ["app_id": APIKeys.openExchange,
                      "base": Constants.defaultCurrencyCode]
        
        let response: Future<CurrencyRateData, NetworkError> = Networking.shared.fetchData(with: apiConfig, andParams: params)
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
            } receiveValue: {[weak self] rates in
                completionHandler(.success(rates))
                Task {
                    await self?.saveFetchedRates(currencyRate: rates)
                }
            }
            .store(in: &cancellables)
    }
}
