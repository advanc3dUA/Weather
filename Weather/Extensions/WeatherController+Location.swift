//
//  WeatherController+Location.swift
//  Weather
//
//  Created by advanc3d on 12.09.2022.
//

import UIKit
import CoreLocation

extension WeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.networkWeatherManager.fetchCurrentWeather(latitude, longitude)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error.localizedDescription)
    }
}
