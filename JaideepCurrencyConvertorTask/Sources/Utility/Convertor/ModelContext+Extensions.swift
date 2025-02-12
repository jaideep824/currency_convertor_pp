//
//  ModelContext+Extensions.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

import Foundation
import SwiftData

protocol ModelContextProtocol {
    func fetch<T>(_ descriptor: FetchDescriptor<T>) throws -> [T] where T: CurrencyRateData
    func insert<T>(_ model: T) where T: CurrencyRateData
    func save() throws
}

extension ModelContext: ModelContextProtocol {}
