//
//  WeatherController + alertController.swift
//  Weather
//
//  Created by advanc3d on 11.09.2022.
//

import UIKit

extension WeatherController {
    func presentSearchAlertController(withTitle title: String?, message: String?, style: UIAlertController.Style, completionHandler: @escaping (String) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: style)
        alertController.addTextField { tf in
            let citiesExamples = ["Alushta", "Simferopol", "Kyiv", "Moscow", "Amsterdam"]
            tf.placeholder = citiesExamples.randomElement()
        }
        
        let searchButton = UIAlertAction(title: "Search", style: .default) { action in
            let textField = alertController.textFields?.first
            guard let cityName = textField?.text else { return }
            if cityName != "" {
                let handledCity = cityName.split(separator: " ").joined(separator: "%20")
                completionHandler(handledCity)
            } else {
                guard let exampleCity = alertController.textFields?.first?.placeholder else { return }
                completionHandler(exampleCity)
            }
        }
        
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(searchButton)
        alertController.addAction(cancelButton)
        
        present(alertController, animated: true)
    }
}
