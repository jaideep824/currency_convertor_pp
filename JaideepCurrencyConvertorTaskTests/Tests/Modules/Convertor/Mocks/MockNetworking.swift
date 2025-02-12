//
//  MockNetworking.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import Combine

class MockNetworking {
    var response: Result<CurrencyRateData, NetworkError>?
    
    func fetchData<T: Decodable>(with config: NetworkConfig, andParams params: [String: String]) -> Future<T, NetworkError> {
        return Future { promise in
            if let response = self.response as? Result<T, NetworkError> {
                promise(response)
            } else {
                promise(.failure(.invalidData))
            }
        }
    }
}
