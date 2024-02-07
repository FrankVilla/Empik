//
//  SearchViewControllerTests.swift
//  EmpikTests
//
//  Created by KOVIGROUP on 07/02/2024.
//

import XCTest
import CoreData
@testable import Empik

class SearchViewControllerTests: XCTestCase {
    
    var viewController: SearchViewController!
    var viewModel: SearchViewModel!
    
    override func setUp() {
        super.setUp()
        viewModel = SearchViewModel()
        viewController = SearchViewController()
        viewController.viewModel = viewModel
        viewController.loadView()
        viewController.viewDidLoad()
    }
    
    override func tearDown() {
        super.tearDown()
        viewController = nil
    }
    
    func testTableViewDataSource() {
        let tableView = viewController.predictionTableView
        XCTAssertNotNil(tableView)
        
        if let dataSource = tableView?.dataSource {
            XCTAssertTrue(dataSource is SearchViewController)
        } else {
            XCTFail("TableView dataSource is nil")
        }
    }
    
    func testTableViewDelegate() {
        let tableView = viewController.predictionTableView
        XCTAssertNotNil(tableView)
        
        if let delegate = tableView?.delegate {
            XCTAssertTrue(delegate is SearchViewController)
            delegate.tableView!(tableView!, didSelectRowAt: IndexPath(row: 0, section: 0))
            delegate.tableView!(tableView!, didSelectRowAt: IndexPath(row: 1, section: 0))
        } else {
            XCTFail("TableView delegate is nil")
        }
    }
}


