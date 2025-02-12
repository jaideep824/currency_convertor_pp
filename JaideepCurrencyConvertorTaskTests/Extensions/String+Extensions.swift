//
//  String+Extensions.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

import Foundation

class BundleHelper {
}

extension String {
    func loadJSON<T: Decodable>() -> T? {
        let bundle = Bundle(for: BundleHelper.self)
        guard let url = bundle.url(forResource: self, withExtension: "json") else {
            return nil
        }
        
        if let jsonData = try? Data(contentsOf: url) {
            let decoder = JSONDecoder()
            do {
                let decodedObject = try decoder.decode(T.self, from: jsonData)
                return decodedObject
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
        return nil
    }
}
