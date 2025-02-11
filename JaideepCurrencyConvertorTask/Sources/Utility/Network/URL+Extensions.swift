//
//  URL+Extensions.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation

extension URL {
    func addingParams(params: [String: String]) -> URL? {
        var urlComponents = URLComponents(string: self.absoluteString)
        urlComponents?.queryItems = params.map { URLQueryItem(name: $0.key, value: $0.value) }
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return nil
        }
        return url
    }
}
