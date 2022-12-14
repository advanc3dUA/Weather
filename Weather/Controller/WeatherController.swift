//
//  ViewController.swift
//  Weather
//
//  Created by advanc3d on 10.09.2022.
//

import UIKit
import CoreLocation

class WeatherController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    lazy var locationManager: CLLocationManager = {
       let lm = CLLocationManager()
        lm.delegate = self
        lm.desiredAccuracy = kCLLocationAccuracyKilometer
        lm.requestWhenInUseAuthorization()
        return lm
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(with: currentWeather)
        }
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestLocation()
        }
    }

    @IBAction func searchAction(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Select your city", message: nil, style: .alert) { [unowned self] handledCity in
            self.networkWeatherManager.fetchCurrentWeather(forRequstType: .cityName(city: handledCity))
        }
    }
    
    private func updateUI(with weather: CurrentWeather) {
        DispatchQueue.main.async {
            self.cityLabel.text = weather.cityName
            self.temperatureLabel.text = weather.temperatureString
            self.feelsLikeTemperatureLabel.text = weather.feelsLikeTemperatureString
            self.weatherIconImageView.image = UIImage(systemName: weather.systemIconNameString)
        }
    }
}

extension WeatherController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude
        self.networkWeatherManager.fetchCurrentWeather(forRequstType: .coordinate(latitude: latitude, longitude: longitude))
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("test")
        print(error.localizedDescription)
        
    }
}
