//
//  CurrencyConvertorView.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 07/02/25.
//

import SwiftUI

// TODO: ViewModel
// TODO: Test Cases
// TODO: Local storage
// TODO: Rate Fetch from remote
// TODO: Accessiblity

struct CurrencyConvertorView: View {
    // MARK: Properties
    @StateObject private var viewModel: ViewModel
   
    // MARK: Body
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                HStack {
                    RoundedCurrencyTextField(placeholder: "enterAValue".localised,
                                             currencyFormat: viewModel.selectedCurrency.code,
                                             inputValue: $viewModel.amount)
                    
                    
                    CurrencyPickerView(placeholder: "selectConversionCurrency".localised,
                                       currencies: viewModel.currencyList(),
                                       selectedCurrency: $viewModel.selectedCurrency)
                        .pickerStyle(.menu)
                        .tint(.appWhite)
                }
                
                CurrencyListView(viewModel: .init(curriencies: viewModel.convertedCurriences()))
            }
            .padding()
            .navigationTitle("convertor".localised)
            .applyBackgroundGradient()
            .onAppear(perform: viewModel.refreshCurrency)
        }
    }
    
    // MARK: - Initialisation
    init(viewModel: ViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
}

#Preview {
    CurrencyConvertorView(
        viewModel: .init(currencyService: CurrencyService())
    )
}
