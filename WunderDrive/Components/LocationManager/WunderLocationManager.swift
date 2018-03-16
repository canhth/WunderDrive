//
//  WunderLocationManager.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CoreLocation
import RxCocoa
import RxSwift

final class WunderLocationManager {
    
    static let sharedInstance = WunderLocationManager()
    private(set) var authorized: Driver<Bool>
    private(set) var location: Driver<CLLocationCoordinate2D>
    private      let disposeBag = DisposeBag()
    private(set) var locationManager = CLLocationManager()
    
    private init() {
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        
        authorized = Observable.deferred { [weak locationManager] in
            let status = CLLocationManager.authorizationStatus()
            guard let locationManager = locationManager else {
                return Observable.just(status)
            }
            return locationManager
                .rx.didChangeAuthorizationStatus
                .startWith(status)
            }
            .asDriver(onErrorJustReturn: CLAuthorizationStatus.notDetermined)
            .map {
                switch $0 {
                case .authorizedAlways, .authorizedWhenInUse:
                    return true
                default:
                    return false
                }
        }
        
        location = locationManager.rx.didUpdateLocations
            .distinctUntilChanged({ $0 }, comparer: { ($0 == $1) })
            .asDriver(onErrorJustReturn: [])
            .flatMap {
                return $0.last.map(Driver.just) ?? Driver.empty()
            }
            .map { $0.coordinate }
        
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func requestAuthorizedLocation() {
        authorized.asObservable().subscribe(onNext: { (status) in
            if !status {
                let alert = UIAlertController(title: "Location Services Disabled", message: "Please enable Location Services in Settings", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
                alert.addAction(okAction)
                
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                return
            }
        }).disposed(by: disposeBag)
    }
}
