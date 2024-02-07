//
//  WeatherServiceTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 04/02/2024.
//

import XCTest
import Combine

class WeatherServiceTests: XCTestCase {
    
    func testFetchWeatherForecast() {
        let service = WeatherService()
        let city = "Paris"
        
        let expectation = self.expectation(description: "Weather forecast received")
        
        var receivedForecast: WeatherForecast?
        var receivedError: WeatherServiceError?
        
        let cancellable = service.fetchWeatherForecast(city: city)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure(let error):
                    receivedError = error
                    expectation.fulfill()
                }
            }, receiveValue: { forecast in
                receivedForecast = forecast
            })
        
        waitForExpectations(timeout: 5, handler: nil)
        
        XCTAssertNotNil(receivedForecast, "Weather forecast should not be nil")
        XCTAssertNil(receivedError, "Error should be nil")
        
        cancellable.cancel()
    }
}

