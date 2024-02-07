//
//  WeatherClient.swift
//  Empik
//
//  Created by KOVIGROUP on 04/02/2024.
//

import Foundation
import Combine

class WeatherClient {
    private let weatherService: WeatherService
    private var cancellable: AnyCancellable?

    init(weatherService: WeatherService = WeatherService()) {
        self.weatherService = weatherService
    }
    /// Requests weather forecast for a specific city and handles the response.
    /// - Parameter city: The name of the city.
    func getWeatherForecast(city: String) -> AnyPublisher<Result<WeatherForecast, WeatherServiceError>, Never> {
        return weatherService.fetchWeatherForecast(city: city)
            .map { Result<WeatherForecast, WeatherServiceError>.success($0) }
            .catch { Just(Result<WeatherForecast, WeatherServiceError>.failure($0)) }
            .eraseToAnyPublisher()
    }
}
