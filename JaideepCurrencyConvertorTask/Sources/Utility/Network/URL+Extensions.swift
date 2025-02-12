//
//  URL+Extensions.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation

extension URL {
    func addingParams(params: [String: String]) -> URL? {
        if params.isEmpty {
            return self
        }
                
        var urlComponents = URLComponents(string: self.absoluteString)
        var queryItems = urlComponents?.queryItems ?? []
        queryItems.append(contentsOf: params.map { URLQueryItem(name: $0.key, value: $0.value) })
        urlComponents?.queryItems = queryItems
        guard let url = urlComponents?.url else {
            print("Invalid URL")
            return nil
        }
        return url
    }
}
