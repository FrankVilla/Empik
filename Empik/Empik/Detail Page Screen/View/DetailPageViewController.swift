//
//  DetailPageViewController.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

// DetailPageViewController.swift

import Foundation
import UIKit
import Combine
import CoreData

class DetailPageViewController: UIViewController, Coordinating {
    var coordinator: Coordinator?
    
    // MARK: - Properties
    var viewModel: DetailPageViewModel!
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var weatherDescriptionLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var minMaxTemperatureLabel: UILabel!
    
    // MARK: - View Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        bindViewModel()
        ConfigureAlert()
        viewModel.loadWeatherDetails()
    }
    
    func ConfigureAlert() {
        viewModel.showAlertClosure = { [weak self] title, message in
            self?.showAlert(title: title, message: message)
        }
    }
    
    func showAlert(title: String, message: String) {
        AlertHelper.showAlert(from: self, title: title, message: message) { _ in
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        clearUIElements()
    }
    
    func saveCityToCoreData(cityName: String) {
        viewModel.saveSearchToCoreData(city: cityName)
    }
    
    func clearUIElements() {
        cityNameLabel.text = nil
        temperatureLabel.text = nil
        weatherDescriptionLabel.text = nil
        windSpeedLabel.text = nil
        iconImageView.image = nil
        minMaxTemperatureLabel.text = nil
    }
    
    // MARK: - Configuration
    func configureView() {
        guard let viewModel = viewModel else {
            return
        }
        cityNameLabel.text = viewModel.city
    }
    
    // MARK: - View Model Binding
    func bindViewModel() {
        viewModel.updates
            .sink { [weak self] in
                self?.updateUI()
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - UI Update
    func updateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if let temperature = self.viewModel.temperature {
                let temperatureCelsius = temperature - 273.15
                let textColor: UIColor = {
                    switch temperatureCelsius {
                    case ..<10: return .blue
                    case 10...20: return .black
                    default: return .red
                    }
                }()
                self.temperatureLabel.text = "\(temperatureCelsius.rounded())°C"
                self.temperatureLabel.textColor = textColor
            } else {
                self.temperatureLabel.text = "N/A"
                self.temperatureLabel.textColor = .black
            }
            self.weatherDescriptionLabel.text = self.viewModel.weatherDescription ?? "N/A"
            if let windSpeed = self.viewModel.windSpeed {
                self.windSpeedLabel.text = "\(windSpeed) m/s"
            } else {
                self.windSpeedLabel.text = "N/A"
            }
            self.iconImageView.image = self.viewModel.weatherIconName.flatMap(UIImage.init(named:)) ?? nil
            if let minTemperatureKelvin = self.viewModel.minTemperature,
               let maxTemperatureKelvin = self.viewModel.maxTemperature {
                let minTempCelsius = minTemperatureKelvin - 273.15
                let maxTempCelsius = maxTemperatureKelvin - 273.15
                self.minMaxTemperatureLabel.text = "Min: \(minTempCelsius.rounded())°C Max: \(maxTempCelsius.rounded())°C"
            } else {
                self.minMaxTemperatureLabel.text = "N/A"
            }
        }
    }
}
