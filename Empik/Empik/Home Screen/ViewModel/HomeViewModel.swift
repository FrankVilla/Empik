//
//  HomeViewModel.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import Foundation
import UIKit
import CoreData
import Combine

class HomeViewModel {
    var coordinator: MainCoordinator?
    var searchHistory: [SearchHistory] = []
    var weatherClient: WeatherClient
    var cancellables: Set<AnyCancellable> = []
    var managedObjectContext: NSManagedObjectContext
    
    init(weatherClient: WeatherClient, coordinator: MainCoordinator?, managedObjectContext: NSManagedObjectContext) {
        self.weatherClient = weatherClient
        self.coordinator = coordinator
        self.managedObjectContext = managedObjectContext
    }
    
    func saveSearchToCoreData(city: String, persistentContainer: NSPersistentContainer) {
        let context = persistentContainer.viewContext
        let searchHistory = SearchHistory(context: context)
        searchHistory.city = city

        do {
            try context.save()
            print("City saved successfully.")
        } catch {
            print("Failed to save city: \(error)")
        }
    }

    func loadSearchHistory() {
        let fetchRequest: NSFetchRequest<SearchHistory> = NSFetchRequest(entityName: "Empik")
        
        do {
            searchHistory = try managedObjectContext.fetch(fetchRequest)
        } catch {
            print("Error loading search history: \(error)")
        }
        if searchHistory.isEmpty {
            print("Search history is empty.")
        }
    }

    func deleteAllSearchHistory() {
    
    }
    
    func deleteSearchHistory(at index: Int) {
        
    }

}

