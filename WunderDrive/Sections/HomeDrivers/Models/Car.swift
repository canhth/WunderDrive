//
//  Car.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import ObjectMapper

typealias Coordinate = (lat: Float, long: Float)

struct Driver: Mappable {
    
    var address             : String = ""
    var engineType          : String = ""
    var exterior            : String = ""
    var coordinates         : [Float] = [Float]()
    var fuel                : Int = 0
    var interior            : String = ""
    var name                : String = ""
    var vin                 : String = ""
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        address             <- map["address"]
        engineType          <- map["engineType"]
        exterior            <- map["exterior"]
        coordinates         <- map["coordinates"]
        fuel                <- map["fuel"]
        interior            <- map["interior"]
        name                <- map["name"]
        vin                 <- map["vin"]
    }
    
    func convertToCoordinateObject() -> Coordinate {
        var coordinate = Coordinate(lat: 0.0, long: 0.0)
        
        guard self.coordinates.count >= 2 else { return coordinate}
        coordinate.lat = self.coordinates[0]
        coordinate.long = self.coordinates[1]
        
        return coordinate
    }
    
}
