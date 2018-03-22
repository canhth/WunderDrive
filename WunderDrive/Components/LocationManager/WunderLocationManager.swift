//
//  WunderLocationManager.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CoreLocation

final class WunderLocationManager: NSObject {
    
    static let sharedInstance = WunderLocationManager()
    private(set) var locationManager = CLLocationManager()
    
    func setupWunderLocationManager() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
}

