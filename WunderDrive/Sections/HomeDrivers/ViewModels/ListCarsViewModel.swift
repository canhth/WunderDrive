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
import CoreLocation

/// Home search ViewModel, based on PaginationNetworkModel
final class ListCarsViewModel: PaginationNetworkModel<Car> {
    
    //MARK: - Variables
    fileprivate(set) var homeSearchService          : SearchDriversServiceProtocol!
    fileprivate(set) var driversResults             = Variable<[Car]>([])
    fileprivate(set) var errorObservable            = PublishSubject<CTNetworkErrorType>()
    fileprivate(set) var isLoadingAnimation         = PublishSubject<Bool>()
    fileprivate(set) var page                       = BehaviorSubject<Int>(value: 1)
    fileprivate      let disposeBag                 = DisposeBag()
    fileprivate      var maxItemPerPage             = 20
    fileprivate      let standarZoomLevel           = 5
    
    //MARK: - Main functions
    
    /// Init ViewModel
    ///
    /// - Parameter homeSearchService: API service
    init(homeSearchService: SearchDriversServiceProtocol) {
        self.homeSearchService = homeSearchService
    }
    
    /// Setup View model to get list Drivers
    ///
    func setupHomeDriversViewModel() {
        
        // --- Setup drivers results list Observable by location updated ---
        var observable : Observable<[Car]>!
        
        WunderLocationManager.sharedInstance.location
            .asObservable()
            .subscribe(onNext: { (location) in
                self.isLoadingAnimation.onNext(true)
                observable = self.homeSearchService.getListDrivers(completion: { [weak self] (drivers, error) in
                    guard let strongSelf = self  else { return }
                    if let error = error {
                        strongSelf.errorObservable.onNext(error as! CTNetworkErrorType)
                    } else {
                        strongSelf.setupModelWithResults(results: drivers)
                    }
                    strongSelf.isLoadingAnimation.onNext(false)
                }).share(replay: 1)
                
                observable.subscribe().disposed(by: self.disposeBag)
            }).disposed(by: disposeBag)
        
    }
    
    //MARK: - Supporting methods
    /// Setup data of view model after fetched results
    ///
    /// - Parameter results: results was found
    fileprivate func setupModelWithResults(results: [Car]) {
        guard results.count > 0 else { return }
        if let currentLocation = WunderLocationManager.sharedInstance.locationManager.location {
            
            self.driversResults.value = results.sorted(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
            self.elements.value = Array(self.driversResults.value.prefix(upTo: maxItemPerPage))
            self.maxOffset = Int(results.count / maxItemPerPage) + 1
        }
    }
    
    /// Lazy loading method
    /// - Parameter offset: the next page
    /// - Returns: Observable that we need to triger
    override func loadData(offset: Int) -> Observable<[Car]> {
        print("Current offset: \(offset)")
        
        // --- Setup drivers results list Observable ---
        var arrayValue = [Car]()
        guard maxOffset > offset else { return Observable.just(arrayValue) }
        
        let lastCurrentIndex = (offset - 1) * self.maxItemPerPage - 1
        if offset >= self.maxOffset - 1 {
            // Return all values in the last page
            arrayValue = Array(self.driversResults.value[lastCurrentIndex..<self.driversResults.value.count])
        } else {
            let nextIndex = lastCurrentIndex + self.maxItemPerPage
            arrayValue = Array(self.driversResults.value[lastCurrentIndex..<nextIndex])
        }
        return Observable.just(arrayValue) 
    }
    
    
    /// Load moew cars when user zoom or dragging map
    ///
    /// - Parameters:
    ///   - zoomValue: currentZoomValue
    ///   - centerLocation: center location of map
    func loadMoreCarWith(zoomValue: Int, centerLocation: CLLocation) {
        
        self.driversResults.value = self.driversResults.value.sorted(by: { $0.distance(to: centerLocation) < $1.distance(to: centerLocation) })
        
        if zoomValue > standarZoomLevel {
            let zoom = zoomValue - standarZoomLevel
            switch zoom {
            case 1:
                maxItemPerPage = 20 * 3
                break
            case 2:
                maxItemPerPage = 20 * 4
                break
            case 3:
                maxItemPerPage = 20 * 6
                break
            default:
                maxItemPerPage = driversResults.value.count
            }
        } else {
            maxItemPerPage = 20
        }
        
        self.elements.value = Array(self.driversResults.value.prefix(upTo: maxItemPerPage))
    }
}
