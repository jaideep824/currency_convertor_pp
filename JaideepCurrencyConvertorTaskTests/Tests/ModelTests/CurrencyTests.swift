//
//  CurrencyTests.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

class CurrencyTests: XCTestCase {
    private var sut: Currency!
    
    func testCurrencyInitialization() {
        let currency = Currency(code: "INR", baseRate: 86.5)
        
        XCTAssertEqual(currency.code, "INR")
        XCTAssertEqual(currency.baseRate, 86.5)
        XCTAssertNil(currency.convertedRate)
        XCTAssertEqual(currency.id, "INR")
    }
    
    func testCurrencyInitializationWithDefaultBaseRate() {
        let currency = Currency(code: "EUR")
        
        XCTAssertEqual(currency.code, "EUR")
        XCTAssertEqual(currency.baseRate, 1)
    }
}
