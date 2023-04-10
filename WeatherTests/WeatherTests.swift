//
//  WeatherTests.swift
//  WeatherTests
//
//  Created by Avinash Thakur on 08/04/23.
//

import XCTest
@testable import Weather

class WeatherTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func testApiBaseUrl() {
      let baseUrl = Constants.baseUrl
      let currentUrl = "https://api.openweathermap.org/data/2.5/weather?"
      XCTAssert(baseUrl != currentUrl)
    }
    
    func imageDownloaderBaseUrl() {
        let imageDownloaderUrl = Constants.imageBaseUrl
        let currentUrl = "https://openweathermap.org/img/wn/"
        XCTAssert(imageDownloaderUrl != currentUrl)
    }

}
