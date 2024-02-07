//
//  Helpers.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import Foundation
import UIKit

class AlertHelper {
    static func showAlert(from viewController: UIViewController, title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let yesAction = UIAlertAction(title: "OK", style: .default) { _ in
            completion(true)
        }
        
        alertController.addAction(yesAction)
        
        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = viewController.view
            popoverController.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.minY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }
        
        viewController.present(alertController, animated: true, completion: nil)
    }
}
