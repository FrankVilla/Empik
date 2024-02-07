//
//  SearchViewController.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import UIKit
import GooglePlaces
import Combine
import Reachability

class SearchViewController: UIViewController, Coordinating {

    // MARK: - Properties
    var coordinator: Coordinator?
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var predictionTableView: UITableView!
    private var viewModel = SearchViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        setupBindings()
        bindViewModel()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchTextField.text = nil
    }
    
    func configureView() {
        title = "Home"
    }
    
    func setupBindings() {
        predictionTableView.dataSource = self
        predictionTableView.delegate = self
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        predictionTableView.register(UITableViewCell.self, forCellReuseIdentifier: "PredictionCell")
    }
    
    func bindViewModel() {
        viewModel.$predictions
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.predictionTableView.reloadData()
            }
            .store(in: &viewModel.cancellables)
    }
    
    // MARK: - User Interaction
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard var searchText = textField.text else { return }
        let invalidCharacters = CharacterSet(charactersIn: "0123456789!@#$%^&*()_+{}[]|\"<>,./?")
        searchText = searchText.components(separatedBy: invalidCharacters).joined(separator: "")
        if textField.text != searchText {
            textField.text = searchText
        }
        viewModel.searchCities(withQuery: searchText)
    }
}

// MARK: - Table View Data Source & Delegate

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.predictions.isEmpty {
            tableView.isHidden = true
            return 0
        } else {
            tableView.isHidden = false
            return viewModel.predictions.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath)
        let prediction = viewModel.predictions[indexPath.row]
        cell.textLabel?.text = prediction.attributedPrimaryText.string
        cell.detailTextLabel?.text = prediction.attributedSecondaryText?.string
        return cell
    }
    
  
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedPrediction = viewModel.predictions[indexPath.row]
            let cityName = selectedPrediction.attributedPrimaryText.string
            print("Selected prediction: \(cityName)")
            coordinator?.eventOccurred(whit: .navigateToDetailPage(city: cityName), city: nil)
        

        }
}
