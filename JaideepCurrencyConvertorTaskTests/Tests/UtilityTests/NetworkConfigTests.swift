//
//  NetworkConfigTests.swift
//  JaideepCurrencyConvertorTaskTests
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

final class NetworkConfigTests: XCTestCase {
    func testNetworkConfigInitializationWithEndpoint() {
        let mockServer = ServerType.openExchange
        let mockEndPoint = EndPoint.currencyRates
        
        let config = NetworkConfig(server: mockServer, requestType: .GET, endPoint: mockEndPoint)
        
        XCTAssertEqual(config.server, mockServer)
        XCTAssertEqual(config.requestType, .GET)
        XCTAssertEqual(config.endPoint, mockEndPoint)
    }
    
    func testNetworkConfigInitializationWithoutEndpoint() {
        let mockServer = ServerType.openExchange
        let config = NetworkConfig(server: mockServer, requestType: .POST, endPoint: nil)
        
        XCTAssertEqual(config.server, mockServer)
        XCTAssertEqual(config.requestType, .POST)
        XCTAssertNil(config.endPoint)
        XCTAssertEqual(config.url?.absoluteString, mockServer.baseURL)
    }
    
    func testURLFormationWithEndpoint() {
        let mockServer = ServerType.openExchange
        let mockEndPoint = EndPoint.currencyRates
        
        let config = NetworkConfig(server: mockServer, requestType: .GET, endPoint: mockEndPoint)
        
        let expectedURL = mockServer.baseURL + mockEndPoint.rawValue
        XCTAssertEqual(config.url?.absoluteString, expectedURL)
    }
}
