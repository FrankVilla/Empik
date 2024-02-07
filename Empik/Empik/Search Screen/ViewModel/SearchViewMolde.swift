//
//  SearchViewMolde.swift
//  Empik
//
//  Created by KOVIGROUP on 03/02/2024.
//

import Foundation
import Combine
import GooglePlaces

class SearchViewModel: ObservableObject {
    @Published var predictions: [GMSAutocompletePrediction] = []
    var cancellables = Set<AnyCancellable>()
    var placesClient = GMSPlacesClient.shared()
    var selectedCity: String?
    func searchCities(withQuery query: String) {
        let token = GMSAutocompleteSessionToken()
        let filter = GMSAutocompleteFilter()
        
        placesClient.findAutocompletePredictions(fromQuery: query, filter: filter, sessionToken: token) { [weak self] (predictions, error) in
            guard let self = self, let predictions = predictions, error == nil else {
                print("Error fetching predictions: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            self.predictions = predictions
        }
    }
}
