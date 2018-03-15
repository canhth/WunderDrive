//
//  ListCarsViewModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import RxCocoa
import RxSwift
import CT_RESTAPI

/// Home search ViewModel, based on PaginationNetworkModel
final class ListCarsViewModel: PaginationNetworkModel<Driver> {
    
    //MARK: - Variables
    fileprivate(set) var driversResults             : Variable<[Driver]>!
    fileprivate(set) var homeSearchService          : SearchDriversServiece!
    fileprivate(set) var errorObservable            = PublishSubject<CTNetworkErrorType>()
    fileprivate(set) var isLoadingAnimation         = PublishSubject<Bool>()
    fileprivate(set) var page                       = BehaviorSubject<Int>(value: 1)
    fileprivate      let disposeBag                 = DisposeBag()
    fileprivate      let maxItemPerPage             = 20
    
    //MARK: - Main functions
    
    /// Init ViewModel
    ///
    /// - Parameter homeSearchService: API service
    init(homeSearchService: SearchDriversServiece) {
        self.homeSearchService = homeSearchService
    }
    
    /// Setup View model to get list Drivers
    ///
    func setupHomeDriversViewModel() {
        isLoadingAnimation.onNext(true)
        
        // --- Setup drivers results list Observable ---
        let observable = homeSearchService.getListDrivers(completion: { [weak self] (drivers, error) in
            if let error = error {
                self?.errorObservable.onNext(error as! CTNetworkErrorType)
            } else {
                self?.setupModelWithResults(results: drivers)
            }
            self?.isLoadingAnimation.onNext(false)
        }).share(replay: 1)
        
        observable.subscribe().disposed(by: disposeBag)
    }
    
    //MARK: - Supporting methods
    
    /// Setup data of view model after fetched results
    ///
    /// - Parameter results: results was found
    fileprivate func setupModelWithResults(results: [Driver]) {
        guard results.count > 0 else { return }
        self.driversResults.value = results
        self.elements.value = Array(results.prefix(upTo: maxItemPerPage))
        self.maxOffset = (results.count % maxItemPerPage) + 1
    }
    
//    /// Lazy loading method
//    ///
//    /// - Parameter offset: the next page
//    /// - Returns: Observable that we need to triger
//    override func loadData(offset: Int) -> Observable<[Driver]> {
//        self.isLoadingAnimation.onNext(true)
//        searchParam.value.page = offset
//        let observable: Observable<[Driver]> = HomeMoviesService.getMoviesArrayWithParam(param: searchParam.value, keyPath: "results")
//            .observeOn(MainScheduler.instance)
//            .map { (value) -> [Movie] in
//                return value
//        }
//        observable.subscribe { (_ ) in
//            self.isLoadingAnimation.onNext(false)
//            }.disposed(by: disposeBag)
//        return observable
//    }
    
}
