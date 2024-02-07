//
//  DetailPageViewControllerTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 07/02/2024.
//

import XCTest
import Combine
import CoreData
@testable import Empik

class DetailPageViewControllerTests: XCTestCase {
    
    var viewController: DetailPageViewController!
    var viewModel: DetailPageViewModel!
    
    override func setUp() {
        super.setUp()
        viewController = DetailPageViewController()
        viewController.viewModel = viewModel
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
        viewModel = nil
    }
    
    func testUIUpdate() {
        viewModel.temperature = 290
        viewModel.weatherDescription = "Sunny"
        viewModel.windSpeed = 3.5 // m/s
        viewModel.minTemperature = 280 // Kelvin
        viewModel.maxTemperature = 300 // Kelvin
        viewModel.weatherIconName = "sunnyIcon"
        viewController.updateUI()
        
        XCTAssertEqual(viewController.temperatureLabel.text, "17°C")
        XCTAssertEqual(viewController.temperatureLabel.textColor, .black)
        XCTAssertEqual(viewController.weatherDescriptionLabel.text, "Sunny")
        XCTAssertEqual(viewController.windSpeedLabel.text, "3.5 m/s")
        XCTAssertNotNil(viewController.iconImageView.image)
        XCTAssertEqual(viewController.minMaxTemperatureLabel.text, "Min: 7°C Max: 27°C")
    }
}

class MockPersistentContainer: NSPersistentContainer {
    override init(name: String, managedObjectModel model: NSManagedObjectModel) {
        super.init(name: name, managedObjectModel: model)
    }
    
    override func newBackgroundContext() -> NSManagedObjectContext {
        return NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
    }
}
