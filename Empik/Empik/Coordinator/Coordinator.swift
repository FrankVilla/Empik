//
//  Coordinator.swift
//  Empik
//
//  Created by KOVIGROUP on 05/02/2024.
//

import Foundation
import UIKit

/// Enum representing various events that can occur within the app.
enum Event {
    case buttonTapped
    case searchCity
    case navigateToDetailPage(city: String) 
}

/// Protocol defining the common behavior for coordinators.
protocol Coordinator {
    /// The navigation controller managed by the coordinator.
    var navigationController: UINavigationController? { get set }
    
    /// Handles different events triggered within the app.
    /// - Parameter type: The type of event that occurred.
    func eventOccurred(whit type: Event, city: String?)
    
    /// Initializes the coordinator and sets up the initial navigation flow.
    func start()
}

/// Protocol for objects that can be coordinated by a coordinator.
protocol Coordinating: AnyObject {
    /// The coordinator associated with the coordinating object.
    var coordinator: Coordinator? { get set }
}
