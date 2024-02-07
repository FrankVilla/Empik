//
//  WeatherClientTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 04/02/2024.
//
import XCTest
import Combine

extension WeatherServiceError: Equatable {
    public static func == (lhs: WeatherServiceError, rhs: WeatherServiceError) -> Bool {
        return false
    }
}

class MockWeatherService: WeatherService {
    let result: Result<WeatherForecast, WeatherServiceError>

    init(result: Result<WeatherForecast, WeatherServiceError>) {
        self.result = result
    }

     func fetchWeatherForecast(city: String) -> AnyPublisher<WeatherForecast, WeatherServiceError> {
        return Result.Publisher(result)
            .eraseToAnyPublisher()
    }
}

class WeatherClientTests: XCTestCase {

    func testGetWeatherForecastFailure() {
        let error = WeatherServiceError.networkError(NSError(domain: "test", code: 42, userInfo: nil))
        let mockService = MockWeatherService(result: .failure(error))
        let client = WeatherClient(weatherService: mockService)
        let city = "Paris"

        let expectation = self.expectation(description: "Weather forecast received")

        var receivedForecast: Result<WeatherForecast, WeatherServiceError>?

        let cancellable = client.getWeatherForecast(city: city)
            .sink(receiveCompletion: { _ in
                expectation.fulfill()
            }, receiveValue: { forecast in
                receivedForecast = forecast
            })

        waitForExpectations(timeout: 5, handler: nil)
        XCTAssertNotNil(receivedForecast, "Weather forecast should not be nil")

        cancellable.cancel()
    }
}
