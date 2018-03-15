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
    fileprivate(set) var homeSearchService          : SearchDriversServiece!
    fileprivate(set) var driversResults             = Variable<[Driver]>([])
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
        self.maxOffset = Int(results.count / maxItemPerPage) + 1
    }
    
    /// Lazy loading method
    /// - Parameter offset: the next page
    /// - Returns: Observable that we need to triger
    override func loadData(offset: Int) -> Observable<[Driver]> {
        print("Current offset: \(offset)")
        
        // --- Setup drivers results list Observable ---
        var arrayValue = [Driver]()
        guard maxOffset > offset else { return Observable.just(arrayValue) }
        
        let lastCurrentIndex = (offset - 1) * self.maxItemPerPage - 1
        if offset >= self.maxOffset - 1 {
            // Return all values in the last page
            arrayValue = Array(self.driversResults.value[lastCurrentIndex..<self.driversResults.value.count])
        } else {
            let nextIndex = lastCurrentIndex + self.maxItemPerPage
            arrayValue = Array(self.driversResults.value[lastCurrentIndex..<nextIndex])
        }
        return Observable.just(arrayValue).throttle(1, scheduler: MainScheduler.instance)
        
    }
    
}
