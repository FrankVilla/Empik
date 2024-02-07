//
//  ConnectivityManager.swift
//  Empik
//
//  Created by KOVIGROUP on 05/02/2024.
//
import UIKit
import Foundation
import Reachability

/// A singleton class responsible for monitoring network reachability using the Reachability framework.
class ConnectivityManager {
    /// Shared instance of `ConnectivityManager`.
    static let shared = ConnectivityManager()
    
    /// Reachability instance for monitoring network status.
    private let reachability = try! Reachability()
    
    /// Private initializer to prevent creating instances of `ConnectivityManager`.
    private init() {}
    
    /// Starts monitoring network reachability.
    func startMonitoring(from viewController: UIViewController) throws {
        try reachability.startNotifier()
        NotificationCenter.default.addObserver(forName: .reachabilityChanged, object: nil, queue: nil) { [weak self] notification in
            self?.reachabilityChanged(notification, from: viewController)
        }
    }
    
    /// Stops monitoring network reachability.
    func stopMonitoring() {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    /// Handles reachability changes and shows an alert if there is no network connection.
    @objc private func reachabilityChanged(_ notification: Notification, from viewController: UIViewController) {
        guard let reachability = notification.object as? Reachability else {
            return
        }
        
        if reachability.connection == .unavailable {
            showAlert(from: viewController)
        }
    }
    
    /// Shows an alert indicating no network connection.
    private func showAlert(from viewController: UIViewController) {
        let alert = UIAlertController(title: "No Connection", message: "You are not connected to the internet.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        viewController.present(alert, animated: true, completion: nil)
    }
}




