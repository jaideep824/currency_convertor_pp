//
//  ContentView.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        CurrencyConvertorView(
            viewModel: .init(currencyHandlingService:CurrencyHandlingService(modelContext: modelContext))
        )
    }
}

#Preview {
    ContentView()
}
