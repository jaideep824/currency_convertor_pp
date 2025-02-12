//
//  CurrencyHandlingServiceTests.swift
//  JaideepCurrencyConvertorTaskTests
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import Combine
import XCTest

final class CurrencyHandlingServiceTests: XCTestCase {
    private let stubData: [CurrencyRateData]? = "CurrencyRateDataStub".loadJSON()
    var sut: CurrencyHandlingService!
    var mockModelContext: MockModelContext!
    var mockNetworking: MockNetworking!
    var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        mockModelContext = MockModelContext()
        mockNetworking = MockNetworking()
        sut = CurrencyHandlingService(modelContext: mockModelContext)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockModelContext = nil
        mockNetworking = nil
        cancellables.removeAll()
    }
    
    func testFetchRates_ReturnsCachedRatesIfNotExpired() {
        let mockRates = stubData![0]
        mockRates.refreshedTimestamp = Int(Date().timeIntervalSince1970)
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85]
        mockModelContext.savedRates = [mockRates]
        
        let expectation = self.expectation(description: "Should return cached rates")
        
        sut.fetchRates(baseCurrency: "USD") { result in
            switch result {
            case .success(let rates):
                XCTAssertEqual(rates.baseCurrencyCode, "USD")
                XCTAssertEqual(rates.rates?["EUR"], 0.85)
            case .failure:
                XCTFail("Should not fail")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 1, handler: nil)
    }
    
    func testCurrencyConversion() {
        let mockRates = stubData![0]
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85, "INR": 74.5]
        sut.currencyRate = mockRates
        
        let convertedAmount = sut.convert(100, from: "EUR", to: "INR")
        XCTAssertNotNil(convertedAmount)
        XCTAssertEqual(convertedAmount!, (100 / 0.85) * 74.5, accuracy: 0.01)
    }
    
    func testConversionFromBaseCurrency() {
        let mockRates = stubData![0]
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85]
        sut.currencyRate = mockRates
        
        let convertedAmount = sut.convertFromBaseCurrency(100, to: "EUR")
        XCTAssertEqual(convertedAmount, 100 * 0.85)
    }
    
    func testRateExpirationCheck() {
        let expiredTimestamp = Int(Date().addingTimeInterval(-3600).timeIntervalSince1970)
        XCTAssertTrue(sut.isRatesExpired(timestamp: expiredTimestamp))
        
        let freshTimestamp = Int(Date().timeIntervalSince1970)
        XCTAssertFalse(sut.isRatesExpired(timestamp: freshTimestamp))
    }
    
    func testSavingFetchedRates() async {
        let mockRates = stubData![0]
        mockRates.baseCurrencyCode = "USD"
        mockRates.rates = ["EUR": 0.85]
        
        await sut.saveFetchedRates(currencyRate: mockRates)
        
        XCTAssertEqual(mockModelContext.savedRates.count, 1)
        XCTAssertEqual(mockModelContext.savedRates.first?.baseCurrencyCode, "USD")
    }
}
