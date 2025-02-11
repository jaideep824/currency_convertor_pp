//
//  CurrencyListView.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

struct CurrencyListView: View {
    // MARK: Properties
    let viewModel: ViewModel
    private let layout: [GridItem] = [GridItem(.adaptive(minimum: 80, maximum: 200))]
    
    // MARK: Body
    var body: some View {
        ScrollView {
            LazyVGrid(columns: layout) {
                ForEach(viewModel.currencyList()) { currency in
                    VStack(alignment: .center) {
                        Text(viewModel.formattedCurrencyRate(for: currency))
                            .foregroundStyle(.appWhite)
                            .font(.body.bold())
                        Text(currency.code)
                            .foregroundStyle(.secondary)
                            .font(.caption.bold())
                        
                    }
                    .frame(height: 50)
                    .padding()
                    .background(.appGreen)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
            }
        }
    }
}

#Preview {
    CurrencyListView(viewModel: .init(curriencies: [.example]))
}
