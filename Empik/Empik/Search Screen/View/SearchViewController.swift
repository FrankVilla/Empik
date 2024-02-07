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
    var viewModel = SearchViewModel()
    private var textFieldSubscription: AnyCancellable?
    
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
    
    deinit {
        textFieldSubscription?.cancel()
    }
}

extension SearchViewController {
    func configureView() {
        title = "Home"
    }
    
    func setupBindings() {
        predictionTableView.dataSource = self
        predictionTableView.delegate = sel
        textFieldSubscription = NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .map { ($0.object as? UITextField)?.text }
            .sink { [weak self] searchText in
                self?.viewModel.searchCities(withQuery: searchText ?? "")
            }
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
}

extension SearchViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.predictions.isEmpty ? 0 : viewModel.predictions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PredictionCell", for: indexPath)
        let prediction = viewModel.predictions[indexPath.row]
        cell.textLabel?.text = prediction.attributedPrimaryText.string
        cell.detailTextLabel?.text = prediction.attributedSecondaryText?.string
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row < viewModel.predictions.count else {return}
        let selectedPrediction = viewModel.predictions[indexPath.row]
        let cityName = selectedPrediction.attributedPrimaryText.string
        print("Selected prediction: \(cityName)")
        coordinator?.eventOccurred(whit: .navigateToDetailPage(city: cityName), city: nil)
    }
}
