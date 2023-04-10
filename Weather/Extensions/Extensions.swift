//
//  Extensions.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import Foundation

extension String {
    
    /**
     Extended function to validate url string and removed unwanted chars if any.
     - Returns: cleaned Url  URL
     */
    func getCleanedURL() -> URL? {
        guard self.isEmpty == false else {
            return nil
        }
        if let url = URL(string: self) {
            return url
        } else {
            if let urlEscapedString = self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) , let escapedURL = URL(string: urlEscapedString){
                return escapedURL
            }
        }
        return nil
    }
    
}
