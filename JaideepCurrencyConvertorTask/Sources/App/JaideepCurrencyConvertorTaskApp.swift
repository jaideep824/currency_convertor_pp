//
//  JaideepCurrencyConvertorTaskApp.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 07/02/25.
//

import SwiftData
import SwiftUI

@main
struct JaideepCurrencyConvertorTaskApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: CurrencyRateData.self)
        }
    }
}
