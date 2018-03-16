//
//  HomeDriversTest.swift
//  WunderDriveTests
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
@testable import WunderDrive

class HomeDriversTest: WunderDriveTests {
        
    // MARK: properties
    var viewModel : ListCarsViewModel!
    let disposeBag = DisposeBag()
    
    let searchDriversService = SearchDriversServiece()
    
    override func setUp() {
        super.setUp()
    }
    
    // MARK: Base functions
    func getResultSuccessWithQuery() -> [Car] {
        viewModel = ListCarsViewModel(homeSearchService: searchDriversService)
        
        var carsResults: [Car]!
        
        // The expectation to wait until got the response from API
        let expectation =  self.expectation(description: "SomeService does stuff and runs the callback closure")
        
        viewModel.setupHomeDriversViewModel() 
         
        let observable = viewModel.homeSearchService.getListDrivers(completion: { (drivers, error) in
            // Just return 22 object from Mock serviece
            carsResults = drivers
            expectation.fulfill()
        })
        observable.subscribe().disposed(by: self.disposeBag)
        
        self.waitForExpectations(timeout: timeOut) { (error) in
            if let error = error {
                XCTFail("waitForExpectationsWithTimeout errored: \(error)")
            }
        }
        
        return carsResults
    }
    
    // MARK: Test cases
    func testGetResultsSuccessAtFirstTime() {
        let carsResults: [Car]! = getResultSuccessWithQuery()
        XCTAssertTrue(carsResults.count > 0)
    }
    
    func testLoadMoreCarsForNextPage() {
        let _ = getResultSuccessWithQuery()
        
        _ = viewModel.loadData(offset: 2)
        _ = viewModel.loadData(offset: 3) 
        XCTAssertTrue(viewModel.elements.value.count >= 20)
    }
}
