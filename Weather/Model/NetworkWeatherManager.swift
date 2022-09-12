//
//  WeatherNetworkManager.swift
//  Weather
//
//  Created by advanc3d on 11.09.2022.
//

import Foundation
import CoreLocation

class NetworkWeatherManager {
    var onCompletion: ((CurrentWeather) ->())?
    
    func fetchCurrentWeather(for city: String) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=\(city)&appid=\(apiKey)&units=metric"
        performRequest(withURLString: urlString)
    }
    
    func fetchCurrentWeather(_ latitude: CLLocationDegrees, _ longitude: CLLocationDegrees) {
        let urlString = "https://api.openweathermap.org/data/2.5/weather?q=lat=\(latitude)&lon=\(longitude)&appid=\(apiKey)&units=metric"
        performRequest(withURLString: urlString)
    }
    
    fileprivate func performRequest(withURLString urlString: String) {
        guard let url = URL(string: urlString) else { return }
        let session = URLSession(configuration: .default)
        let task = session.dataTask(with: url) { data, response, error in
            guard let data = data else { return }
            if let currentWeather = self.parseJSON(withData: data) {
                self.onCompletion?(currentWeather)
            }
        }
        task.resume()
    }
    
    fileprivate func parseJSON(withData data: Data) -> CurrentWeather? {
        let decoder = JSONDecoder()
        do {
            let currentWeatherData = try decoder.decode(CurrentWeatherData.self, from: data)
            guard let currentWeather = CurrentWeather(with: currentWeatherData) else { return nil }
            return currentWeather
        }
    
        catch let error as NSError {
            print(error.localizedDescription)
        }
        return nil
    }
}
