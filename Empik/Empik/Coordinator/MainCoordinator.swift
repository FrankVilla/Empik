//
//  MainCoordinator.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import Foundation
import UIKit
import CoreData

class MainCoordinator: Coordinator {
    // MARK: - Properties
    
    /// The navigation controller managing the navigation stack.
    var navigationController: UINavigationController?
    var selectedCity: String?
    // MARK: - Coordinator Methods
    
    /// Handles various events within the app, such as button taps or navigation requests.
    /// - Parameter type: The type of event that occurred.
    func eventOccurred(whit type: Event, city: String?) {
           switch type {
           case .buttonTapped:
               // Navigate to HomeViewController when a button is tapped.
               let homeViewController: UIViewController & Coordinating = SearchViewController()
               homeViewController.coordinator = self
               navigationController?.pushViewController(homeViewController, animated: true)
               
           case .searchCity:
               // Navigate to SearchViewController for city searches.
               navigateToSearchCity()
               
               // Navigate to DetailPageViewController with the specified city.
           case let .navigateToDetailPage(city: city):
               navigateToDetailPage(city: city)
           }
       }

    /// Initializes the app's navigation stack with HomeViewController as the root.
    func start() {
        let homeViewController: HomeViewController & Coordinating = HomeViewController()
        homeViewController.coordinator = self
        homeViewController.title = "Home"
        navigationController?.setViewControllers([homeViewController], animated: false)
    }

    /// Navigates to the SearchViewController.
    func navigateToSearchCity() {
        let searchCityViewController: SearchViewController & Coordinating = SearchViewController()
        searchCityViewController.coordinator = self
        searchCityViewController.title = "Search City"
        navigationController?.pushViewController(searchCityViewController, animated: true)
    }
    
    /// Navigates to the DetailPageViewController with the specified city.
    /// - Parameter city: The city for which to display details.
    func navigateToDetailPage(city: String) {
        let persistentContainer = NSPersistentContainer(name: "Empik")
        persistentContainer.loadPersistentStores { [weak self] (storeDescription, error) in
            guard let self = self else { return }
            if let error = error as NSError? {
                fatalError("Error al cargar el NSPersistentContainer: \(error), \(error.userInfo)")
            }

            let detailPageViewModel = DetailPageViewModel(city: city, persistentContainer: persistentContainer)
            let detailPageViewController = DetailPageViewController()
            detailPageViewController.viewModel = detailPageViewModel
            detailPageViewController.coordinator = self
            detailPageViewController.title = "Detail Page"
            self.navigationController?.pushViewController(detailPageViewController, animated: true)
        }
    }
}
