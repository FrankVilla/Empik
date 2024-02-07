//
//  HomeViewController.swift
//  Empik
//
//  Created by KOVIGROUP on 02/02/2024.
//

import Foundation
import UIKit
import CoreData
import Combine
import Reachability

class HomeViewController: UIViewController, Coordinating, UISearchBarDelegate {
    var coordinator: Coordinator?
    var dataTableView: UITableView!
    var viewModel: HomeViewModel?
    
    override func loadView() {
        if let customView = Bundle.main.loadNibNamed("HomeViewController", owner: self, options: nil)?.first as? UIView {
            view = customView
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startConnectivityMonitoring()
        configureUI()
        setupTableView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
    }
}

extension HomeViewController {
    func configureUI() {
        configureNavigationBar()
    }
    
    func configureView() {
        guard let viewModel = viewModel else { return }
        viewModel.loadSearchHistory()
    }
    
    func setupTableView() {
        configureTableView()
        dataTableView.dataSource = self
        dataTableView.register(UITableViewCell.self, forCellReuseIdentifier: "reuseIdentifier")
    }
    
    func configureTableView() {
        dataTableView = UITableView(frame: view.bounds, style: .plain)
        dataTableView.frame.origin.y = 310
        view.addSubview(dataTableView)
    }
    
    func configureNavigationBar() {
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: .plain, target: self, action: #selector(searchButtonTapped))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func searchButtonTapped() {
        let cityName = ""
        coordinator?.eventOccurred(whit: .searchCity, city: cityName)
    }
    
    func startConnectivityMonitoring() {
        do {
            try ConnectivityManager.shared.startMonitoring(from: self)
        } catch {
            print("Error starting connectivity monitoring: \(error)")
        }
    }
    
    // MARK: - UISearchBarDelegate
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else {return}
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let viewModel = viewModel else { return 0 }
        return viewModel.searchHistory.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let viewModel = viewModel else {
            fatalError("ViewModel is nil")
        }
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let city = viewModel.searchHistory[indexPath.row].city
        cell.textLabel?.text = city
        return cell
    }
}
