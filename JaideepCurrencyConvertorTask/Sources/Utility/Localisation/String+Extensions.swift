//
//  String+Extensions.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 11/02/25.
//

import Foundation

extension String {
    var localised: String {
        NSLocalizedString(self, tableName: "Common", comment: "")
    }
}
