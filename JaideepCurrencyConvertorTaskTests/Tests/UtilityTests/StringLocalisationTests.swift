//
//  StringLocalisationTests.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

class LocalisationTests: XCTestCase {

    func testLocalisedStringExists() {
        let key = "enterAValue"
        let expectedValue = "Please enter a value"

        XCTAssertEqual(key.localised, expectedValue)
    }

    func testLocalisedStringReturnsKeyIfMissing() {
        let missingKey = "non_existent_key"
        XCTAssertEqual(missingKey.localised, missingKey)
    }
}
