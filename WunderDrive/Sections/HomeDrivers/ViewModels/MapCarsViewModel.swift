//
//  MapCarsViewModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 22/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import MapViewPlus
import CoreLocation
import CT_RESTAPI

final class MapCarsViewModel: HomeMapViewModel {
    
    //MARK: - Variables and confirm protocol
    fileprivate(set) var homeSearchService          : SearchDriversServiceProtocol!
    fileprivate      var maxItemPerPage             = 20
    fileprivate      let standarZoomLevel           = 5
    
    var mapViewDelegate: HomeMapListViewModelDelegate?
    
    var listItems: [Car] = [Car] ()
    
    fileprivate(set) var cars: [Car]! {
        didSet {
            let annotations = self.createAnnotationsPlaceMarks(by: self.cars)
            mapViewDelegate?.didCreatedPlaceMarks(placeMarks: annotations)
        }
    }
    
    //MARK: - Main functions
    
    /// Init ViewModel
    /// - Parameter homeSearchService: API service
    init(homeSearchService: SearchDriversServiceProtocol) {
        self.homeSearchService = homeSearchService
        self.setupMapDriversViewModel()
    }
    
    /// Setup View model to get list Drivers
    ///
    func setupMapDriversViewModel() {
        // --- Setup drivers results list by location  ---
        self.homeSearchService.getListDrivers(completion: { [weak self] (drivers, error) in
            guard let strongSelf = self  else { return }
            if let error = error {
                Helper.showAlertViewWith(error: error.toError() as! CTNetworkErrorType)
            } else {
                if let currentLocation = WunderLocationManager.sharedInstance.locationManager.location {
                    
                    strongSelf.listItems = drivers.sorted(by: { $0.distance(to: currentLocation) < $1.distance(to: currentLocation) })
                    strongSelf.cars = Array(strongSelf.listItems.prefix(upTo: strongSelf.maxItemPerPage))
                }
            }
        })
    }
    
    //MARK: - Supporting methods
    
    /// Load more cars when user zoom or dragging map
    ///
    /// - Parameters:
    ///   - zoomValue: currentZoomValue
    ///   - centerLocation: center location of map
    func loadMoreItemsOnMap(zoomLevel: Int, centerLocation: CLLocation) {
        
        self.listItems = self.listItems.sorted(by: { $0.distance(to: centerLocation) < $1.distance(to: centerLocation) })
        
        if zoomLevel > standarZoomLevel {
            let zoom = zoomLevel - standarZoomLevel
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
                maxItemPerPage = listItems.count
            }
        } else {
            maxItemPerPage = 20
        }
        guard self.cars.count > 0 else { return }
        self.cars.append(contentsOf: Array(self.listItems.prefix(upTo: maxItemPerPage)))
    }
    
    fileprivate func createAnnotationsPlaceMarks(by cars: [Car]) -> [AnnotationPlus] {
        var annotations: [AnnotationPlus] = []
        cars.forEach { (driver) in
            annotations.append(AnnotationPlus(viewModel: PlaceMarkModel(driver: driver), coordinate: driver.convertToCoordinateObject()))
        }
        return annotations
    }
}
