//
//  SearchDriversServiece.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import CT_RESTAPI
import Alamofire

typealias SearchDriversServiceCompletionHandler = (_ results: [Car], _ error: Error?) -> Void

protocol SearchDriversServiceProtocol {
    func getListDrivers(completion: @escaping SearchDriversServiceCompletionHandler) -> Observable<[Car]>
}

final class SearchDriversServiece: SearchDriversServiceProtocol {
    
    /// Get drivers list
    ///
    /// - Parameters:
    ///   - completion: Results and error of API
    /// - Returns: Observable<[Car]>
    func getListDrivers(completion: @escaping SearchDriversServiceCompletionHandler) -> Observable<[Car]> {
        
        let apiManager = RESTApiClient(subPath: "wunderbucket", functionName: "locations.json", method: .GET, endcoding: .URL)
        
        return apiManager.requestObjects(keyPath: "placemarks")
            .observeOn(MainScheduler.instance)
            .catchError({ (error) -> Observable<[Car]> in
                completion([], error as! CTNetworkErrorType)
                return Observable.empty()
            })
            .map { (results) -> [Car] in
                if results.count > 0 {
                    completion(results, nil)
                    return results
                }
                else {
                    completion([], nil)
                    return []
                }
        }
    }
    
    func createFakePagingLoading() -> Observable<[Car]> {
        return Observable.create { observer -> Disposable in
            request("https://www.google.com/",
                    method: HTTPMethod.get)
                .responseData(queue: DispatchQueue.main, completionHandler: {(_) in
                    observer.onNext([])
                    observer.onCompleted()
                })

            return Disposables.create {}
            }.do(onError: { (error) in
            }) 
        
//        let apiManager = RESTApiClient(subPath: "wunderbucket", functionName: "locations.json", method: .GET, endcoding: .URL)
//
//        return apiManager.requestObjects(keyPath: "placemarks")
    }

}
