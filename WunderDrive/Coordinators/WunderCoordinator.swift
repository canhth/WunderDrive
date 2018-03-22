//
//  AppCoordinator.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 21/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CoreLocation

class WunderCoordinator : Coordinator {
    fileprivate var window: UIWindow
    
    init(window: UIWindow) {
        
        self.window = window
    }
    
    func startToLoadView() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            case .notDetermined, .restricted, .denied:
                showRequestShareLocation()
            case .authorizedAlways, .authorizedWhenInUse:
                showBaseHomeView()
            }
        } else {
            print("Location services are not enabled")
            showRequestShareLocation()
        }
    }
}

extension WunderCoordinator {
    
    fileprivate func showRequestShareLocation() {
        
        let requestPermissionCoordinator = RequestPermissionCoordinator(window: window)
        requestPermissionCoordinator.delegate = self
        requestPermissionCoordinator.startToLoadView()
    }
    
    fileprivate func showBaseHomeView() {
        let homePageCoordinator = HomePageCoordinator(window: window)
        homePageCoordinator.startToLoadView()
    }
}


extension WunderCoordinator : RequestPermissionDelegate {
    func locationAuthorizedDidChange(isAuthorized: Bool) {
        if isAuthorized {
            showBaseHomeView()
        } else {
            showRequestShareLocation()
        }
    }
}
