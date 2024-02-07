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
    var persistentContainer: NSPersistentContainer
    
    init(weatherClient: WeatherClient, coordinator: MainCoordinator?, managedObjectContext: NSManagedObjectContext, persistentContainer: NSPersistentContainer) {
        self.weatherClient = weatherClient
        self.coordinator = coordinator
        self.managedObjectContext = managedObjectContext
        self.persistentContainer = persistentContainer
    }
}

extension HomeViewModel {
    func saveSearchToCoreData(city: String, persistentContainer: NSPersistentContainer) {
        let context = persistentContainer.viewContext
        let searchHistory = SearchHistory(context: context)
        searchHistory.cityName = city
        
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
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Empik")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try managedObjectContext.execute(deleteRequest)
            try managedObjectContext.save()
            print("All search history deleted successfully.")
        } catch {
            print("Failed to delete search history: \(error)")
        }
    }
}
