//
//  Car.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import CoreLocation

typealias Coordinate = (lat: Double, long: Double)

struct PlaceMarksResponse: Decodable {
    var placemarks: [Car] = []
}

struct Car: Decodable {
    
    var address             : String = ""
    var engineType          : String = ""
    var exterior            : String = ""
    var coordinates         : [Double] = [Double]()
    var fuel                : Int = 0
    var interior            : String = ""
    var name                : String = ""
    var vin                 : String = ""
    
    func convertToCoordinateObject() -> CLLocationCoordinate2D {
        var coordinate = Coordinate(lat: 0.0, long: 0.0)
        
        guard self.coordinates.count >= 2 else { return CLLocationCoordinate2D(latitude: 0,longitude: 0)}
        coordinate.long = self.coordinates[0]
        coordinate.lat = self.coordinates[1]
        
        return CLLocationCoordinate2DMake(coordinate.lat, coordinate.long)
    }
    
    func distance(to location: CLLocation) -> CLLocationDistance {
        let locationCoordinate = self.convertToCoordinateObject()
        let objectLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        return location.distance(from: objectLocation)
    }
    
}
