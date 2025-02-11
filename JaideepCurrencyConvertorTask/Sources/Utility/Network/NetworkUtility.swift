//
//  NetworkUtility.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation

enum ServerType {
    case openExchange
    
    var baseURL: String {
        switch self {
        case .openExchange:
            return "https://openexchangerates.org/api/"
        }
    }
}

enum EndPoint: String {
    case currencyRates = "latest.json"
    case currencyList = "currencies.json"
}

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case parsingError
    case deinitialisedBeforeHandling
    case somethingWentWrong
}

enum RequestType: String {
    case GET, POST
}
