//
//  HomeMapViewModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 22/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import CoreLocation
import MapViewPlus

protocol HomeMapListViewModelDelegate {
    func didCreatedPlaceMarks(placeMarks: [AnnotationPlus])
}

protocol HomeMapViewModel
{
    var mapViewDelegate: HomeMapListViewModelDelegate? { get set }
    
    var listItems: [Car] { get set }
    
    func loadMoreItemsOnMap(zoomLevel: Int, centerLocation: CLLocation)
}
