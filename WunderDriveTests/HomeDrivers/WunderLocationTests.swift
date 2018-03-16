//
//  WunderLocationTests.swift
//  WunderDriveTests
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import XCTest
import RxSwift
import RxCocoa
import CoreLocation
@testable import WunderDrive

class WunderLocationTests: WunderDriveTests {
        
    func testDidUpdateLocations() {
        var completed = false
        var location: CLLocation?
        
        let targetLocation = CLLocation(latitude: 90, longitude: 180)
        
        autoreleasepool {
            let manager = CLLocationManager()
            
            _ = manager.rx.didUpdateLocations.subscribe(onNext: { l in
                location = l[0]
            }, onCompleted: {
                completed = true
            })
            
            manager.delegate!.locationManager!(manager, didUpdateLocations: [targetLocation])
        }
        
        XCTAssertEqual(location?.coordinate.latitude, targetLocation.coordinate.latitude)
        XCTAssertEqual(location?.coordinate.longitude, targetLocation.coordinate.longitude)
        XCTAssertTrue(completed)
    }
    
    func testDidFailWithError() {
        var completed = false
        autoreleasepool {
            let manager = CLLocationManager()
            
            _ = manager.rx.didFailWithError.subscribe(onNext: { e in 
            }, onCompleted: {
                completed = true
            })
            
            manager.delegate!.locationManager!(manager, didFailWithError: testError)
        }
        
        XCTAssertTrue(completed)
    }
    
}


enum TestError: Error {
    case dummyError
    case dummyError1
    case dummyError2
}
let testError = TestError.dummyError
let testError1 = TestError.dummyError1
let testError2 = TestError.dummyError2
