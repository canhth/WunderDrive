//
//  HomeMoviesService.swift
//  CanhTran
//
//  Created by Tran Hoang Canh on 7/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CT_RESTAPI

typealias SearchMovieServiceCompletionHandler = (_ results: MovieResults?, _ error: Error?) -> Void
protocol SearchMovieService {
    func getMoviesWithParam(param: SearchMovieParams, completion: @escaping SearchMovieServiceCompletionHandler) -> Observable<MovieResults?>
}

final class HomeMoviesService: SearchMovieService {
    
    
    /// Get movies with param of Search Movie Service
    ///
    /// - Parameters:
    ///   - param: search param
    ///   - completion: Results and error of API
    /// - Returns: Observable<MovieResults?>
    func getMoviesWithParam(param: SearchMovieParams, completion: @escaping SearchMovieServiceCompletionHandler) -> Observable<MovieResults?> {
        return self.getMoviesWithParam(param: param)
            .observeOn(MainScheduler.instance)
            .catchError({ (error) -> Observable<MovieResults?> in
                completion(nil, error as! CTNetworkErrorType)
                return Observable.empty()
            })
            .map { (result) -> MovieResults in
                if let value = result, value.totaResults > 0 {
                    completion(result, nil)
                    return value
                }
                else {
                    completion(nil, nil)
                    return MovieResults()
                }
        }
    }
    
    /// Create RESTApiClient
    ///
    /// - Parameter param: object Param
    /// - Returns: MovieResults Observable
    func getMoviesWithParam(param: SearchMovieParams) -> Observable<MovieResults?> {
        
        let apiManager = RESTApiClient(subPath: "search", functionName: "movie", method: .POST, endcoding: .URL)
        apiManager.setQueryParam(param.dictionary)
        
        return apiManager.requestObject(keyPath: nil)
    }
    
    
    /// Get array of Movie
    ///
    /// - Parameters:
    ///   - param: object Param
    ///   - keyPath: keyPath of array JSON
    /// - Returns: array [Movie]
    class func getMoviesArrayWithParam(param: SearchMovieParams, keyPath: String) -> Observable<[Movie]> {
        
        let apiManager = RESTApiClient(subPath: "search", functionName: "movie", method: .POST, endcoding: .URL)
        apiManager.setQueryParam(param.dictionary)
        
        return apiManager.requestObjects(keyPath: keyPath)
    }
}
