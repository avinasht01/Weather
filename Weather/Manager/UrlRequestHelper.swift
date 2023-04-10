//
//  UrlRequestHelper.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation

class UrlRequestHelper {
    
    /**
     Function request data from server for given url using URLSession
     - Parameter url: URL Sets location tracking on /off
     - Returns: completion  Returns completion handler with request data and error if any.
     */
    func requestDataForUrl(url: URL, completion: @escaping (Data?, Error?) -> Void) {
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(
            with: request, completionHandler: { data, response, error in
                if error == nil {
                    guard let resultData = data else {
                        let error = NSError(domain: "Api Result Error", code: 101, userInfo: ["Desc" : "No data found"])
                        completion(nil, error)
                        return
                    }
                    completion(resultData, nil)
                } else {
                    completion(nil, error)
                }
            })
        task.resume()
    }
    
    /**
     Function request image data from server for given url using URLSession
     - Parameter url: String  Sets location tracking on /off
     - Returns: completion  Returns completion handler with requested image data and error if any.
     */
    func downloadImage(url: String, completion: @escaping (Data?, Error?) -> Void) {
        if let url = URL(string: url) {
            let task = URLSession.shared.dataTask(with: url) { data, response, error in
                guard let data = data, error == nil else {
                    completion(nil, error)
                    return
                }
                completion(data, nil)
            }
            task.resume()
        }
    }
    
}
