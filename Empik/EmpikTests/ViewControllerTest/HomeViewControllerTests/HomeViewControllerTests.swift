//
//  HomeViewControllerTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 07/02/2024.
//

import XCTest

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
        // Assuming ConnectivityManager always starts monitoring successfully
        XCTAssertNoThrow(try viewController.startConnectivityMonitoring())
    }

    func testStartConnectivityMonitoringFailure() {
        // Assuming ConnectivityManager throws an error when monitoring fails
        ConnectivityManager.shared.mockError = NSError(domain: "MockErrorDomain", code: 123, userInfo: nil)
        
        XCTAssertThrowsError(try viewController.startConnectivityMonitoring())
    }
}
