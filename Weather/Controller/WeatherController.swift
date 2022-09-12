//
//  ViewController.swift
//  Weather
//
//  Created by advanc3d on 10.09.2022.
//

import UIKit

class WeatherController: UIViewController {

    @IBOutlet weak var weatherIconImageView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var feelsLikeTemperatureLabel: UILabel!
    
    var networkWeatherManager = NetworkWeatherManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        networkWeatherManager.onCompletion = { [weak self] currentWeather in
            guard let self = self else { return }
            self.updateUI(with: currentWeather)
        }
        self.networkWeatherManager.fetchCurrentWeather(for: "London")
    }

    @IBAction func searchAction(_ sender: UIButton) {
        self.presentSearchAlertController(withTitle: "Select your city", message: nil, style: .alert) { [unowned self] handledCity in
            self.networkWeatherManager.fetchCurrentWeather(for: handledCity)
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
