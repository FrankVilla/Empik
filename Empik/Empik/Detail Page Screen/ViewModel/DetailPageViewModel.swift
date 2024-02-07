//
//  DetailPageViewModel.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import Foundation
import UIKit
import Combine
import CoreData

class DetailPageViewModel {
    var city: String
    var temperature: Double?
    var minTemperature: Double?
    var maxTemperature: Double?
    var weatherDescription: String?
    var windSpeed: Double?
    var weatherIconName: String?
    var cancellables: Set<AnyCancellable> = []
    let weatherService: WeatherService
    var showAlertClosure: ((String, String) -> Void)?
    let persistentContainer: NSPersistentContainer
    
    private var updatesSubject = PassthroughSubject<Void, Never>()
    var updates: AnyPublisher<Void, Never> {
        return updatesSubject.eraseToAnyPublisher()
    }
    
    init(city: String, weatherService: WeatherService = WeatherService(), persistentContainer: NSPersistentContainer) {
        self.city = city
        self.weatherService = weatherService
        self.persistentContainer = persistentContainer 
    }
    
    func saveSearchToCoreData(city: String) {
            let context = persistentContainer.viewContext
            let searchHistory = SearchHistory(context: context)
            searchHistory.cityName = city

            do {
                try context.save()
                print("City saved successfully.")
            } catch {
                print("Failed to save city: \(error)")
            }
        }
    
    
    func loadWeatherDetails() {
        weatherService.fetchWeatherForecast(city: city)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("Weather details loaded successfully")
                case .failure(let error):
                    print("Failed to load weather details: \(error)")
                    self.showAlertClosure?("Error", "The selected city is not available. Please try again later. tarde.")

                }
            },
                  receiveValue: { [weak self] weatherForecast in
                print("Received weather forecast:", weatherForecast)
                self?.temperature = weatherForecast.main.temp
                self?.minTemperature = weatherForecast.main.temp_min
                self?.maxTemperature = weatherForecast.main.temp_max
                self?.weatherDescription = weatherForecast.weather.first?.description ?? "N/A"
                self?.windSpeed = weatherForecast.wind.speed
                self?.weatherIconName = weatherForecast.weather.first?.icon
                self?.updatesSubject.send()
            })
            .store(in: &cancellables)
    }
}

