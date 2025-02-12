//
//  DateExtensionTests.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

final class DateExtensionTests: XCTestCase {
    func testDefaultDateFormatting() {
        let date = Date(timeIntervalSince1970: 0)
        let expectedString = "1970-01-01 05:30:00"
        
        XCTAssertEqual(date.toString(), expectedString)
    }
    
    func testCustomDateFormatting() {
        let date = Date(timeIntervalSince1970: 0)
        let customFormat = "dd/MM/yyyy"
        let expectedString = "01/01/1970"
        
        XCTAssertEqual(date.toString(format: customFormat), expectedString)
    }
    
    func testDateFormattingWithTimeZone() {
        let date = Date(timeIntervalSince1970: 0)
        let utcTimeZone = TimeZone(abbreviation: "UTC")!
        let expectedString = "1970-01-01 00:00:00"
        
        XCTAssertEqual(date.toString(timeZone: utcTimeZone), expectedString)
    }
    
    func testDateFormattingWithDifferentTimeZone() {
        let date = Date(timeIntervalSince1970: 0)
        let estTimeZone = TimeZone(abbreviation: "EST")!
        let expectedString = "1969-12-31 19:00:00"
        
        XCTAssertEqual(date.toString(timeZone: estTimeZone), expectedString)
    }
}
