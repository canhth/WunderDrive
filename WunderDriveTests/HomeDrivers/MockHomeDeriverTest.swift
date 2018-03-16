//
//  MockHomeDeriverTest.swift
//  WunderDriveTests
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import XCTest
@testable import WunderDrive

extension HomeDriversTest {
    
    // Mock serviece
    func testMockResultsWithSuccess() {
        
        viewModel = ListCarsViewModel(homeSearchService: MockHomeMoviesService())
        
        var carsResults: [Car]!
        
        let observable = viewModel.homeSearchService.getListDrivers(completion: { (drivers, error) in
            // Just return 22 object from Mock serviece
            carsResults = drivers
        })
        observable.subscribe().disposed(by: self.disposeBag)
        
        XCTAssertTrue(carsResults.count > 0)
    }
    
}
