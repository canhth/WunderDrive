//
//  HomeSearchUITests.swift
//  CareemMovieUITests
//
//  Created by Tran Hoang Canh on 9/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import XCTest

class HomeSearchUITests: BaseUITest {
    
    // MARK: - Base functions
    func scrollTableViewToLoadMore(tableView: XCUIElement) {
        waitUntilElementExists(tableView)
        while tableView.cells.count <= 20 {
            tableView.swipeUp()
        }
        sleep(3)
        XCTAssert(tableView.cells.count > 20)
    }
    
    // MARK: - Test cases
    
    func testLoadListDriversSuccess() {
        let tableView = app.tables.firstMatch
        waitUntilElementExists(tableView)
        
        scrollTableViewToLoadMore(tableView: tableView)
    }
    
    func testOpenMapView() {
        // Wait to load list in table view success first
        let mapTabbar = app.tabBars["Maps"]
        waitUntilElementExists(mapTabbar)
        mapTabbar.tap()
        
        let mapView = app.maps.firstMatch
        XCTAssert(mapView.exists)
    }
    
    // Nothing more...
}
