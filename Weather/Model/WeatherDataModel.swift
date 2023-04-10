//
//  WeatherDataModel.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation

/// Weather Data Model Struct
struct WeatherData: Codable {
    
    var main : MainWeatherData?
    var weather = [Weather]()
    var base: String?
    var clouds: Clouds?
    var cod: Int?
    var coord: Coordinates?
    var dt: Int?
    var id: Int?
    var name: String?
    var sys: System?
    var timezone: Int?
    var visibility: Int?
    var wind: Wind?
}

struct MainWeatherData: Codable {
    var feels_like: Double
    var humidity: Int
    var pressure: Int
    var temp: Double
    var temp_max: Double
    var temp_min: Double
}

struct Weather: Codable {
    var description: String?
    var icon: String?
    var id: Int?
    var main: String?
}

struct Clouds: Codable {
    var all: Int?
}

struct Coordinates: Codable {
    var lat: Double?
    var lon: Double?
}

struct System: Codable {
    var country: String?
    var id: Int?
    var sunrise: Int?
    var sunset: Int?
    var type: Int?
}

struct Wind: Codable {
    var deg: Int?
    var speed: Double?
}
