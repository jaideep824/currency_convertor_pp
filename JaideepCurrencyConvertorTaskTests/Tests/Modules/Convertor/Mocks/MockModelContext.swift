//
//  MockModelContext.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import SwiftData

class MockModelContext: ModelContextProtocol {
    var savedRates: [CurrencyRateData] = []
    
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T: CurrencyRateData {
        return savedRates as! [T]
    }
    
    func insert<T>(_ model: T) where T: CurrencyRateData {
        savedRates.append(model)
    }
    
    func save() throws {
        
    }
}
