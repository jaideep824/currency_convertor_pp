//
//  CurrencyRateDataTests.swift
//  JaideepCurrencyConvertorTask
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

class CurrencyRateDataTests: XCTestCase {
    private var stubData: [CurrencyRateData]?
    private var sut: CurrencyRateData!
    
    override func setUpWithError() throws {
        stubData = "CurrencyRateDataStub".loadJSON()
    }
    
    override func tearDownWithError() throws {
        stubData = nil
        sut = nil
    }
    
    func testSUTShouldNotNil() {
        sut = stubData?[0]
        XCTAssertNotNil(sut)
    }
    
    func testDataMappingIsCorrect() {
        sut = stubData?[0]
        
        XCTAssertEqual(sut.refreshedTimestamp, 1700000000)
        XCTAssertEqual(sut.baseCurrencyCode, "USD")
        XCTAssertEqual(sut.rates?.count, 2)
        XCTAssertEqual(sut.currencies?.count, 2)
        XCTAssertEqual(sut.currencies?.first, Currency(code: "EUR", baseRate: 0.85))
        XCTAssertEqual(sut.currencies?.last, Currency(code: "INR", baseRate: 86.0))
    }
    
    func testDataMappingIsNil() {
        sut = stubData?[1]
        
        XCTAssertNotNil(sut)
        XCTAssertNil(sut.refreshedTimestamp)
        XCTAssertNil(sut.baseCurrencyCode)
        XCTAssertNil(sut.rates)
        XCTAssertNil(sut.currencies)
    }
    
    func testDataMappingIsEmpty() {
        sut = stubData?[2]
        
        XCTAssertNotNil(sut)
        XCTAssertEqual(sut.baseCurrencyCode, "USD")
        XCTAssertEqual(sut.refreshedTimestamp, 1700000000)
        XCTAssertEqual(sut.rates?.count, 0)
        XCTAssertEqual(sut.currencies?.count, 0)
    }
}
