//
//  SearchDriversServiece.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CT_RESTAPI 

typealias SearchDriversServiceCompletionHandler = (_ results: [Car], _ error: RESTError?) -> Void

protocol SearchDriversServiceProtocol {
    func getListDrivers(completion: @escaping SearchDriversServiceCompletionHandler)
}

final class SearchDriversServiece: SearchDriversServiceProtocol {
    
    /// Get drivers list
    ///
    /// - Parameters:
    ///   - completion: Results and error of API
    /// - Returns: <[Car]>
    func getListDrivers(completion: @escaping SearchDriversServiceCompletionHandler) {
        
        let apiManager = RESTApiClient(subPath: "wunderbucket", functionName: "locations.json", method: .GET, endcoding: .URL)
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        apiManager.baseRequest { (results, error) in
            if let jsonData = results as? Data {
                do {
                    let results: PlaceMarksResponse = try JSONDecoder().decode(PlaceMarksResponse.self, from: jsonData)
                    completion(results.placemarks, nil)
                } catch {
                    print("Error when parsing JSON: \(error)")
                }
            } else {
                completion([], error)
            }
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
        }
    }
    
    
}
