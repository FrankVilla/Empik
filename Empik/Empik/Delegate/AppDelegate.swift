//
//  AppDelegate.swift
//  Empik
//
//  Created by KOVIGROUP on 02/02/2024.
//

import UIKit
import CoreData
import GooglePlaces

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var coordinator: MainCoordinator?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        GMSPlacesClient.provideAPIKey("YOU APIKEY")
        let navegationCon = UINavigationController()
        coordinator = MainCoordinator()
        coordinator?.navigationController = navegationCon
        
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = navegationCon
        window?.makeKeyAndVisible()
        coordinator?.start()
        return true
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Empik")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container 
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
