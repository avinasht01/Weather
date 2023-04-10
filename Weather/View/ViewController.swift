//
//  ViewController.swift
//  Weather
//
//  Created by Avinash Thakur on 08/04/23.
//

import UIKit
import MapKit

class ViewController: UIViewController {
    
    var model: WeatherViewModel?
    let locationManager = CLLocationManager()
    var location: CLLocation!
    var locationName: String!
    @IBOutlet weak var currentLocationButton: UIButton!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var minTempLabel: UILabel!
    @IBOutlet weak var maxTempLabel: UILabel!
    @IBOutlet weak var decriptionLabel: UILabel!
    
    var resultSearchController: UISearchController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialiseViewModel()
        initializeLocationManager()
        initializeSearchController()
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        model?.loadWeatherDetailsForLastSavedLocation()
    }
    
    /// Function initialises view model
    private func initialiseViewModel() {
        model = WeatherViewModel()
        model?.delegate = self
    }
    
    /// Function initialises view location manager.
    private func initializeLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }
    
    /// Function initialises search bar controller to search for places.
    private func initializeSearchController() {
        let locationSearchTable = storyboard!.instantiateViewController(withIdentifier: "LocationSearchTable") as! LocationSearchTable
        locationSearchTable.delegate = self
        resultSearchController = UISearchController(searchResultsController: locationSearchTable)
        resultSearchController?.searchResultsUpdater = locationSearchTable
        
        let searchBar = resultSearchController!.searchBar
        searchBar.sizeToFit()
        searchBar.placeholder = "Search for places to get weather details"
        navigationItem.searchController = resultSearchController
        
        resultSearchController?.hidesNavigationBarDuringPresentation = false
        definesPresentationContext = true
    
    }
    
    /// Button action to fetch current location.
    @IBAction func currentLocationButtonTapped(_ sender: UIButton) {
        locationManager.requestLocation()
    }
    
    /**
     Function request for weather data to display on the view.
     - Parameter inputLocation: CLLocation Location
     */
    func getWeatherDetails(inputLocation: CLLocation) {
        location = inputLocation
        AppUserDefaults.setLatitude(latitude: location.coordinate.latitude)
        AppUserDefaults.setLongitude(longitude: location.coordinate.longitude)
        model?.getWeatherResultForLocation(lat: location.coordinate.latitude, long: location.coordinate.longitude)
    }
    
    /// Function displays error alert if the location could not fetched.
    func showFailureAlert() {
        let alert = UIAlertController(title: "Error", message: "Sorry could not fetch the weather report", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .destructive, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    

}

// MARK: - CLLocationManagerDelegate
extension ViewController: CLLocationManagerDelegate {
    

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse {
            locationManager.requestLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let loc = locations.first {
            getWeatherDetails(inputLocation: loc)
        }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location Error: \(error)")
    }
}


// MARK: - Extention to get City Details from Placemark
extension ViewController {
    
    func getPlace(for location: CLLocation,
                  completion: @escaping (CLPlacemark?) -> Void) {
        
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(location) { placemarks, error in
            
            guard error == nil else {
                print("*** Error in \(#function): \(error!.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("*** Error in \(#function): placemark is nil")
                completion(nil)
                return
            }
            
            completion(placemark)
        }
    }
    
    func getCityNameFrom(placemark: CLPlacemark) {
        
        self.getPlace(for: location) { placemark in
            guard let placemark = placemark else { return }

            var output = "Our location is:"
            if let country = placemark.country {
                output = output + "\n\(country)"
            }
            if let state = placemark.administrativeArea {
                output = output + "\n\(state)"
            }
            if let town = placemark.locality {
                self.locationName = town
                self.model?.getWeatherResultForLocation(lat: self.location.coordinate.latitude, long: self.location.coordinate.longitude)
                output = output + "\n\(town)"
            }
            print("the placemark details: \(output)")
        }
    }
   
}

// MARK: - WeatherViewModelDelegate Functions
extension ViewController: WeatherViewModelDelegate {
    
    func didReceiveFailure() {
        showFailureAlert()
    }
    
    func didReceiveWeatherResult(result: WeatherData) {
        
        DispatchQueue.main.async {
            self.resultSearchController?.searchBar.text = ""
            if let temp = result.main?.temp {
                let valueInCelcius = temp - Constants.kelvinConversionValue
                self.minTempLabel.text = " Temperature: \(String(format: "%.2f", valueInCelcius)) C"
            }
            
            if let minTemp = result.main?.temp_min, let maxTemp = result.main?.temp_max {
                let minvalueInCelcius = minTemp - Constants.kelvinConversionValue
                let maxvalueInCelcius = maxTemp - Constants.kelvinConversionValue
                self.maxTempLabel.text = " Min: \(String(format: "%.2f", minvalueInCelcius)) C  Max: \(String(format: "%.2f", maxvalueInCelcius)) C"
            }
            
            if let city = result.name {
                self.cityLabel.text = city
            }
            
            let weatherDetail = result.weather[0]
                if let icon = weatherDetail.icon {
                    self.model?.getImageFor(imageName: icon, completion: { data, error in
                        guard let imgData = data, error == nil else {
                            return
                        }
                        DispatchQueue.main.async { /// execute on main thread
                                   self.weatherIcon.image = UIImage(data: imgData)
                               }
                    })
                }
                if let desc = weatherDetail.description {
                    self.decriptionLabel.text = desc
                }
        }
    }
    
}

// MARK: - UISearchResultsDelegate
extension ViewController: UISearchResultsDelegate {
    
    func didSelectPlace(placemark: CLPlacemark) {
        resultSearchController?.dismiss(animated: true, completion: nil)
        guard let loc = placemark.location else {
            showFailureAlert()
            return
        }
        getWeatherDetails(inputLocation: loc)
    }
    
}
