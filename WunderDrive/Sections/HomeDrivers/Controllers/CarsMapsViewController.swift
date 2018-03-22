//
//  CarsMapsViewController.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit 
import MapViewPlus
import MapKit

class CarsMapsViewController: UIViewController {
    
    //MARK: - IBOutlets & Variables
    @IBOutlet weak var mapView: MapViewPlus!
    
    fileprivate weak var currentCalloutView: UIView? 
    fileprivate let viewModel = MapCarsViewModel(homeSearchService: SearchDriversServiece())
    fileprivate let locationManager = WunderLocationManager.sharedInstance.locationManager
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewModel()
    }

    fileprivate func setupViews() {
        
        let buttonItem = MKUserTrackingBarButtonItem(mapView: mapView)
        self.navigationItem.rightBarButtonItem = buttonItem

        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.mapType = .standard
        mapView.userTrackingMode = .followWithHeading
        locationManager.startUpdatingLocation()
        mapView.anchorViewCustomizerDelegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestAlwaysAuthorization()
        }
        
        locationManager.startUpdatingHeading()
    
    }
    
    fileprivate func setupViewModel() {
        viewModel.mapViewDelegate = self
    }
    
    fileprivate func getZoomLevelOfMap() -> Int {
        let zoomWidth = mapView.visibleMapRect.size.width
        let zoomFactor = Int(log2(zoomWidth)) - 9
        print("...REGION DID CHANGE: ZOOM FACTOR \(zoomFactor)")
        return zoomFactor
    }
    
    fileprivate func getCenterCoordinateOfMap() -> CLLocation {
        return CLLocation(latitude: mapView.centerCoordinate.latitude, longitude: mapView.centerCoordinate.longitude)
    }
}

//MARK: MapViewPlush Delegate
extension CarsMapsViewController: MapViewPlusDelegate {
    func mapView(_ mapView: MapViewPlus, imageFor annotation: AnnotationPlus) -> UIImage {
        return UIImage(named: "icon_car_placemark")!
    }
    
    func mapView(_ mapView: MapViewPlus, calloutViewFor annotationView: AnnotationViewPlus) -> CalloutViewPlus {
        let calloutView = Bundle.main.loadNibNamed("DriverPinMarkView", owner: nil, options: nil)!.first as! DriverPinMarkView
        currentCalloutView = calloutView
        return calloutView
    }
}

extension CarsMapsViewController: AnchorViewCustomizerDelegate {
    func mapView(_ mapView: MapViewPlus, fillColorForAnchorOf calloutView: CalloutViewPlus) -> UIColor {
        return currentCalloutView?.backgroundColor ?? mapView.defaultFillColorForAnchors
    }
}

//MARK: Original MapKitDelegate
extension CarsMapsViewController: MKMapViewDelegate, CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        // Zoom to user location
        if let userLocation = userLocation.location {
            let viewRegion = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 2000, 2000)
            mapView.setRegion(viewRegion, animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        let zoomLevel = self.getZoomLevelOfMap()
        let centerLocation = self.getCenterCoordinateOfMap()
        viewModel.loadMoreItemsOnMap(zoomLevel: zoomLevel, centerLocation: centerLocation)
    }
}

extension CarsMapsViewController: HomeMapListViewModelDelegate {
    
    func didCreatedPlaceMarks(placeMarks: [AnnotationPlus]) {
        DispatchQueue.main.async {
            self.mapView.setup(withAnnotations: placeMarks)
        }
    }
}
