//
//  CurrencyConvertorView.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 07/02/25.
//

import SwiftData
import SwiftUI

struct CurrencyConvertorView: View {
    // MARK: Properties
    @StateObject private var viewModel: ViewModel
   
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack {
                    RoundedCurrencyTextField(placeholder: "enterAValue".localised,
                                             currencyFormat: viewModel.selectedCurrencyCode,
                                             inputValue: $viewModel.amount)
                    
                    
                    CurrencyPickerView(placeholder: "selectConversionCurrency".localised,
                                       currencies: viewModel.currencyList(),
                                       selectedCurrency: $viewModel.selectedCurrencyCode)
                        .pickerStyle(.menu)
                        .tint(.appWhite)
                }
                
                CurrencyListView(viewModel: .init(curriencies: viewModel.convertedCurriences()))
                
                if let lastSyncTime = viewModel.lastSyncTime() {
                    Text("Using rates: \(lastSyncTime)")
                        .font(.footnote.italic())
                        .foregroundStyle(.appYellow)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .tint(.appWhite)
            .padding([.horizontal, .top])
            .navigationTitle("convertor".localised)
            .applyBackgroundGradient()
            .onAppear {
                viewModel.refreshCurrency()
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Refresh", systemImage: "arrow.clockwise", action: viewModel.forceRefreshDataFromRemote)
                }
            }
        }
    }
    
    // MARK: - Initialisation
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

struct CurrencyConvertorViewPreview: View {
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        CurrencyConvertorView(
            viewModel: .init(currencyHandlingService: CurrencyHandlingService(modelContext: modelContext))
        )
    }
}

#Preview {
    CurrencyConvertorViewPreview()
        .modelContainer(for: CurrencyRateData.self)
}
