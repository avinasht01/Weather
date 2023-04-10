//
//  AppConstants.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation

struct Constants {
    
    static let baseUrl = "https://api.openweathermap.org/data/2.5/weather?"
    static let imageBaseUrl = "https://openweathermap.org/img/wn/"
    static let imageEndPoint = "@2x.png"
    
    static func getApiKey() -> String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "WeatherApiKey") as? String else {
            return ""
        }
        return apiKey
    }
    
    static let kelvinConversionValue = 273.15
}

struct AppUserDefaults {
    
    static func setLatitude(latitude: Double) {
      UserDefaults.standard.set(latitude, forKey: "latitude")
    }

    static func setLongitude(longitude: Double) {
      UserDefaults.standard.set(longitude, forKey: "longitude")
    }

    static func getLatitude() -> Double? {
      let defaults = UserDefaults.standard
      return defaults.double(forKey: "latitude")
    }

    static func getLongitude() -> Double? {
      let defaults = UserDefaults.standard
      return defaults.double(forKey: "longitude")
    }
    
}
