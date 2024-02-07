//
//  WeatherModel.swift
//  Empik
//
//  Created by KOVIGROUP on 04/02/2024.
//

import Foundation

struct WeatherForecast: Codable {
    let coord: Coord
    let weather: [WeatherInfo]
    let base: String
    let main: MainInfo
    let visibility: Int
    let wind: WindInfo
    let clouds: CloudsInfo
    let dt: Int
    let sys: SysInfo
    let timezone: Int
    let id: Int
    let name: String
    let cod: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}

struct WeatherInfo: Codable {
    let id: Int
    let main: String
    let description: String
    let icon: String
}

struct MainInfo: Codable {
    let temp: Double
    let feels_like: Double
    let temp_min: Double
    let temp_max: Double
    let pressure: Int
    let humidity: Int
}

struct WindInfo: Codable {
    let speed: Double
    let deg: Int
}

struct CloudsInfo: Codable {
    let all: Int
}

struct SysInfo: Codable {
    let type: Int
    let id: Int
    let country: String
    let sunrise: Int
    let sunset: Int
}
