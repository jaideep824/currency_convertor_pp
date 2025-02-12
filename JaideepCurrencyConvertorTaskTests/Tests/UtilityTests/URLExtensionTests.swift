//
//  URLExtensionTests.swift
//  JaideepCurrencyConvertorTaskTests
//
//  Created by Jaideep on 12/02/25.
//

@testable import JaideepCurrencyConvertorTask
import XCTest

final class URLExtensionTests: XCTestCase {
    func testAddingParamsWithValidURL() {
        let baseURL = URL(string: "https://example.com")!
        let params = ["key": "value", "user": "JohnDoe"]
        
        let modifiedURL = baseURL.addingParams(params: params)
        let urlComponents = URLComponents(string: modifiedURL?.absoluteString ?? "")
        let queryItems = urlComponents?.queryItems ?? []
        
        
        XCTAssertNotNil(modifiedURL)
        XCTAssertEqual(Set(queryItems), Set([URLQueryItem(name: "user", value: "JohnDoe"), URLQueryItem(name: "key", value: "value")]))
    }
    
    func testAddingParamsWithEmptyParams() {
        let baseURL = URL(string: "https://example.com")
        let params: [String: String] = [:]
        
        let modifiedURL = baseURL?.addingParams(params: params)
        
        XCTAssertNotNil(modifiedURL)
        XCTAssertEqual(modifiedURL?.absoluteString, "https://example.com")
    }
    
    func testAddingParamsToURLWithExistingQuery() {
        let baseURL = URL(string: "https://example.com?existing=123")!
        let params = ["newKey": "newValue"]
        
        let modifiedURL = baseURL.addingParams(params: params)
        
        XCTAssertNotNil(modifiedURL)
        XCTAssertEqual(modifiedURL?.absoluteString, "https://example.com?existing=123&newKey=newValue")
    }
}
