//
//  WeatherService.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation
import UIKit

class WeatherService {
    let apiKey = Constants.getApiKey()
        
    /**
     Function request weather for given latitude and longitude values.
     - Parameter latitude: Double Sets location tracking on /off
     - Parameter longitude: Double Sets location tracking on /off
     
     - Returns: completion  Returns completion handler with weather data and error if any.
     */
    func getWeatherResultForLocation(latitude: Double, longitude: Double, completion: @escaping (WeatherData?, Error?) -> Void) {
        if apiKey != "" {
            let urlString = "\(Constants.baseUrl)lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)"
            guard let url = urlString.getCleanedURL() else {
                print("the url not working")
                let error = NSError(domain: "Api Error", code: 101, userInfo: ["Desc" : "Invalid url"])
                completion(nil, error)
                return
            }
            
            UrlRequestHelper().requestDataForUrl(url: url) { data, error in
                if let weatherData = data {
                    let decoder = JSONDecoder()
                    do {
                        let weather = try decoder.decode(WeatherData.self, from: weatherData)
                        print("the weather result: \(weather)")
                        completion(weather, nil)
                    } catch {
                        let error = NSError(domain: "Api Error", code: 101, userInfo: ["Desc" : "Invalid url"])
                        completion(nil, error)
                    }
                }
            }
        } else {
            let error = NSError(domain: "Api Error", code: 101, userInfo: ["Desc" : "No Api Key found"])
            completion(nil, error)
        }
    }
    
}
