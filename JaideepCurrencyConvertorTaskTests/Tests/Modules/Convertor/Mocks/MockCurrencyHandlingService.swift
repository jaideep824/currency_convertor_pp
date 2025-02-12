//
//  MockCurrencyHandlingService.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import Foundation

class MockCurrencyHandlingService: CurrencyHandlingService {
    var mockRates: CurrencyRateData?
    var shouldFail = false
    
    override func fetchRates(baseCurrency: String, forceReload: Bool = false, completion: @escaping (Result<CurrencyRateData, Error>) -> Void) {
        if shouldFail {
            completion(.failure(NSError(domain: "NetworkError", code: 500, userInfo: nil)))
        } else if let mockRates {
            completion(.success(mockRates))
        }
    }
    
    override func convert(_ amount: Double, from sourceCurrency: String?, to targetCurrency: String?) -> Double? {
        guard let sourceCurrency, let targetCurrency else { return nil }
        return (amount * 2.0)
    }
}
