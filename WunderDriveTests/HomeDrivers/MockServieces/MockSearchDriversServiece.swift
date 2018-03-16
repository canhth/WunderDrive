//
//  MockSearchDriversServiece.swift
//  WunderDriveTests
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CT_RESTAPI
@testable import WunderDrive

class MockHomeMoviesService: SearchDriversServiceProtocol {
    
    /// Mock func
    ///
    /// - Parameters:
    ///   - completion: Results and error of API
    /// - Returns: Observable<[Car]>
    func getListDrivers(completion: @escaping SearchDriversServiceCompletionHandler) -> Observable<[Car]> {
        
        // We will face three cars for the response
        var array = [Car()]
        for _ in 0...20 {
            array.append(Car())
        }
        completion(array, nil)
        return Observable.just(array)
    }
    
   
     
}
