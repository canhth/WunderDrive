//
//  RequestPermissionViewController.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 21/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CoreLocation

protocol RequestPermissionViewControllerDelegate: class {
    func didAuthorizedAfterShowedViewController()
}

class RequestPermissionViewController: UIViewController {

    var delegate: RequestPermissionViewControllerDelegate!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        WunderLocationManager.sharedInstance.locationManager.delegate = self
        WunderLocationManager.sharedInstance.setupWunderLocationManager()
        
    }

}

extension RequestPermissionViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.delegate.didAuthorizedAfterShowedViewController()
        } else if(status == .denied){
            print("Denied!!!")
        }
    }
}
