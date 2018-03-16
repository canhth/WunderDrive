//
//  PlaceMarkModel.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 16/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import MapViewPlus

class PlaceMarkModel: CalloutViewModel {
    var driver: Car!
    
    init(driver: Car) {
        self.driver = driver
    }
}

