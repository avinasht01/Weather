//
//  ViewModel.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation

protocol WeatherViewModelDelegate: NSObjectProtocol {
    
    func didReceiveWeatherResult(result: WeatherData)
    func didReceiveFailure()
}

class WeatherViewModel: NSObject {
    
    weak var delegate: WeatherViewModelDelegate?
    
    override init() {
        
    }
    
    /**
     Function loads  weather  data for last stored location details and updates the view controller to update view.
     - Parameter latitude: Double Sets location tracking on /off
     - Parameter longitude: Double Sets location tracking on /off
     */
     func loadWeatherDetailsForLastSavedLocation() {
        if let latitude = AppUserDefaults.getLatitude(), let longitude = AppUserDefaults.getLongitude() {
            self.getWeatherResultForLocation(lat: latitude, long: longitude)
        }
    }
    
    /**
     Function loads  weather  data for input location  and updates the view controller to update view.
     - Parameter lat: Double Sets location tracking on /off
     - Parameter long: Double Sets location tracking on /off
     */
    func getWeatherResultForLocation(lat: Double, long: Double) {
        WeatherService().getWeatherResultForLocation(latitude: lat, longitude: long) { weatherResult, error in
            guard let weatherReport = weatherResult else {
                self.delegate?.didReceiveFailure()
                return
            }
            self.delegate?.didReceiveWeatherResult(result: weatherReport)
        }
    }
    
    /**
     Function loads weather icon image.
     - Parameter imageName: String Image name
     - Returns: completion  Returns completion handler with image  data and error if any.
     */
    func getImageFor(imageName: String, completion: @escaping (Data?, Error?) -> Void) {
        let imageUrlString = Constants.imageBaseUrl + imageName + Constants.imageEndPoint
        UrlRequestHelper().downloadImage(url: imageUrlString) { data, error in
            guard let imgData = data, error == nil else {
                completion(nil, error)
                return
            }
            completion(imgData, nil)
        }
    }
    
}
