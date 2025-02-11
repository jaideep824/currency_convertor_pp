//
//  BackgroundGradient.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import SwiftUI

struct BackgroundGradient: ViewModifier {
    func body(content: Content) -> some View {
        ZStack {
            AngularGradient(colors: [.appBlue, .appGreen, .appPink, .appRed, .appWhite, .appYellow], center: .trailing)
                .ignoresSafeArea()
            content
        }
    }
}

extension View {
    func applyBackgroundGradient() -> some View {
        self
            .modifier(BackgroundGradient())
    }
}
