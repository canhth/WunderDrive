//
//  ListCarsViewModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import CT_RESTAPI
import CoreLocation

final class ListCarsViewModel: HomeListViewModel {
    
    //MARK: - Variables & confirm protocol
    fileprivate(set) var homeSearchService          : SearchDriversServiceProtocol!
    fileprivate(set) var totalItems                 : [Car] = [Car]()
    fileprivate(set) var page                       : Int = 1
    fileprivate      var maxItemPerPage             = 20
    fileprivate      var maxOffset                  = 20
    
    var listViewDelegate: HomeListViewModelViewDelegate?
    
    var numberOfItems: Int {
        if let cars = cars {
            return cars.count
        }
        return 0
    }
    
    func itemAtIndex(_ index: Int) -> Car? {
        if let cars = cars , cars.count > index {
            return cars[index]
        }
        return nil
    }
    
    fileprivate(set) var cars: [Car]? {
        didSet {
            listViewDelegate?.listCarsDidChanged()
        }
    }
    
    //MARK: - Main functions
    
    /// Init ViewModel
    /// - Parameter homeSearchService: API service
    init(homeSearchService: SearchDriversServiceProtocol) {
        self.homeSearchService = homeSearchService
        setupHomeDriversViewModel()
    }
    
    /// Setup View model to get list Drivers
    ///
    func setupHomeDriversViewModel() {
        
        // --- Setup drivers results list by location  ---
        self.homeSearchService.getListDrivers(completion: { [weak self] (drivers, error) in
            guard let strongSelf = self  else { return }
            if let error = error {
                Helper.showAlertViewWith(error: error.toError() as! CTNetworkErrorType)
            } else {
                strongSelf.setupModelWithResults(results: drivers)
            }
        })
    }
    
    //MARK: - Supporting methods
    /// Setup data of view model after fetched results
    ///
    /// - Parameter results: results was found
    fileprivate func setupModelWithResults(results: [Car]) {
        guard results.count > 0 else { return }
        if let currentLocation = WunderLocationManager.sharedInstance.locationManager.location {
            
            totalItems = results.sorted(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
            self.cars = Array(totalItems.prefix(upTo: maxItemPerPage))
            self.maxOffset = Int(results.count / maxItemPerPage) + 1
        } else {
            Helper.showAlertViewWith(message: "Could you please setup share location on Simulator by go to Debug->Location->CustomLocation (53.570493, 9.985019) and retry again")
        }
    }
    
    /// Lazy loading method
    /// - Parameter offset: the next page
    func loadDataOfNextPage() {
        
        page += 1
        print("Current offset: \(page)")
        
        // --- Setup drivers results list Observable ---
        var arrayValue = [Car]()
        guard maxOffset > page else { return }
        
        let lastCurrentIndex = (page - 1) * self.maxItemPerPage - 1
        if page >= self.maxOffset - 1 {
            // Return all values in the last page
            arrayValue = Array(totalItems[lastCurrentIndex..<totalItems.count])
        } else {
            let nextIndex = lastCurrentIndex + self.maxItemPerPage
            arrayValue = Array(totalItems[lastCurrentIndex..<nextIndex])
        }
        self.cars?.append(contentsOf: arrayValue)
    }
    
}
