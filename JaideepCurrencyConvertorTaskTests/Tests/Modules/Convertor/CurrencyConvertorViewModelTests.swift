//
//  CurrencyConvertorViewModelTests.swift
//  JaideepCurrencyConvertorTaskTests
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import Combine
import XCTest

final class CurrencyConvertorViewModelTests: XCTestCase {
    private let stubData: [CurrencyRateData]? = "CurrencyRateDataStub".loadJSON()
    var sut: CurrencyConvertorView.ViewModel!
    var mockService: MockCurrencyHandlingService!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockService = MockCurrencyHandlingService(modelContext: MockModelContext())
        sut = CurrencyConvertorView.ViewModel(currencyHandlingService: mockService)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockService = nil
        cancellables.removeAll()
    }
    
    func testViewModelInitialization() {
        XCTAssertEqual(sut.amount, "0.00")
        XCTAssertEqual(sut.selectedCurrencyCode, Constants.defaultCurrencyCode)
        XCTAssertNil(sut.currencyRateData)
        XCTAssertTrue(sut.convertedCurriences().isEmpty)
    }
    
    func testFetchCurrencyRates_Success() {
        let mockRates = stubData![0]
        mockRates.refreshedTimestamp = Int(Date().timeIntervalSince1970)
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85, "INR": 74.5]
        mockService.mockRates = mockRates
        
        let expectation = self.expectation(description: "Currency rates should be fetched successfully")
        
        sut.refreshCurrency()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNotNil(self.sut.currencyRateData)
            XCTAssertEqual(self.sut.currencyRateData?.baseCurrencyCode, "USD")
            XCTAssertEqual(self.sut.currencyRateData?.rates?["EUR"], 0.85)
            XCTAssertEqual(self.sut.currencyRateData?.rates?["INR"], 74.5)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testFetchCurrencyRates_Failure() {
        mockService.shouldFail = true
        
        let expectation = self.expectation(description: "Currency rates fetch should fail")
        
        sut.refreshCurrency()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertNil(self.sut.currencyRateData)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
    
    func testCurrencyConversion_Success() {
        let mockRates = stubData![0]
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85, "INR": 74.5]
        sut.currencyRateData = mockRates
        sut.amount = "100"
        
        let convertedCurrencies = sut.convertCurriences(amount: "100", from: "USD", utilising: mockRates)
        
        XCTAssertEqual(convertedCurrencies.count, 2)
        XCTAssertEqual(convertedCurrencies.first?.code, "EUR")
        XCTAssertEqual(convertedCurrencies.first?.convertedRate, 200.0)
    }
    
    func testLastSyncTime_ValidTimestamp() {
        let mockRates = stubData![0]
        mockRates.refreshedTimestamp = 1700000000
        sut.currencyRateData = mockRates
        
        let syncTime = sut.lastSyncTime()
        XCTAssertEqual(syncTime, "2023-11-15 03:43:20")
    }
    
    func testLastSyncTime_NoData() {
        sut.currencyRateData = nil
        XCTAssertNil(sut.lastSyncTime())
    }
    
    func testDebounceTriggersCurrencyConversion() {
        let mockRates = stubData![0]
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85, "INR": 74.5]
        sut.currencyRateData = mockRates
        
        let expectation = self.expectation(description: "Debounce should trigger currency conversion")
        
        sut.amount = "100"
        sut.selectedCurrencyCode = "USD"
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            XCTAssertFalse(self.sut.convertedCurriences().isEmpty)
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 2, handler: nil)
    }
}
