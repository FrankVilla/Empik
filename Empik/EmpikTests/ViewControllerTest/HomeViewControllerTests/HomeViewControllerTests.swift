//
//  HomeViewControllerTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 07/02/2024.
//

import XCTest
@testable import Empik

class HomeViewControllerTests: XCTestCase {
    var viewController: HomeViewController!
    
    override func setUp() {
        super.setUp()
        viewController = HomeViewController()
    }
    
    override func tearDown() {
        viewController = nil
        super.tearDown()
    }
    
    func testStartConnectivityMonitoringSuccess() {
        XCTAssertNoThrow(viewController.startConnectivityMonitoring())
    }
}
