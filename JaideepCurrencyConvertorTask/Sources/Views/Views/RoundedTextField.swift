//
//  RoundedTextField.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

struct RoundedCurrencyTextField: View {
    let placeholder: String
    let currencyFormat: String
    @Binding var inputValue: String
    
    var body: some View {
        TextField(placeholder, text: $inputValue)
            .padding(.horizontal, 12)
            .frame(height: 50)
            .background(.appWhite)
            .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    RoundedCurrencyTextField(placeholder: "enterAValue".localised,
                             currencyFormat: "USD",
                             inputValue: .constant("10"))
}
