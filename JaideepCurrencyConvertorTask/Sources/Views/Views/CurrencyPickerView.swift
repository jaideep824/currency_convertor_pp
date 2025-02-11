//
//  CurrencyPickerView.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

struct CurrencyPickerView: View {
    let placeholder: String
    let currencies: [Currency]
    @Binding var selectedCurrency: Currency
    
    var body: some View {
        Picker(placeholder, selection: $selectedCurrency) {
            ForEach(currencies) { currency in
                Text(currency.code)
                    .foregroundStyle(.appYellow)
                    .bold()
            }
        }
    }
}

#Preview {
    CurrencyPickerView(placeholder: "selectConversionCurrency".localised,
                       currencies: [.example],
                       selectedCurrency: .constant(.example))
}
