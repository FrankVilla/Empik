//
//  WeatherService.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import UIKit
import Combine

enum WeatherServiceError: Error {
    case invalidURL
    case invalidResponse
    case networkError(Error)
    case decodingError(Error)
}

class WeatherService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    private let apiKey = "YOU APIKEY"

    /// Fetches weather forecast for a specific city.
    ///
    /// - Parameter city: The name of the city.
    /// - Returns: A publisher with the weather forecast or an error.
    func fetchWeatherForecast(city: String, session: URLSession = .shared) -> AnyPublisher<WeatherForecast, WeatherServiceError> {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(apiKey)") else {
            return Fail(error: WeatherServiceError.invalidURL).eraseToAnyPublisher()
        }

        return session.dataTaskPublisher(for: url)
            .mapError { error -> WeatherServiceError in
                .networkError(error)
            }
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                    throw WeatherServiceError.invalidResponse
                }
                return data
            }
            .decode(type: WeatherForecast.self, decoder: JSONDecoder())
            .mapError { error -> WeatherServiceError in
                .decodingError(error)
            }
            .eraseToAnyPublisher()
    }
}

