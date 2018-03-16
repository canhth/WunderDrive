//
//  DriverPinMarkView.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import MapViewPlus

class DriverPinMarkView: UIView {

    // MARK: - IBOutlets 
    @IBOutlet weak fileprivate var carNameLabel: UILabel!
    @IBOutlet weak fileprivate var fluelLabel: UILabel!
    @IBOutlet weak fileprivate var typeEngineLabel: UILabel!
    @IBOutlet weak fileprivate var exteriorLabel: UILabel!
    @IBOutlet weak fileprivate var interiorLabel: UILabel!
    @IBOutlet weak fileprivate var addressLabel: UILabel!
    
    override func draw(_ rect: CGRect) {
        self.layer.applySketchShadow(color: UIColor.shadowColor, alpha: 0.7, x: 0, y: 4, blur: 8, spread: 0)
    }

}

extension DriverPinMarkView: CalloutViewPlus {
    
    func configureCallout(_ viewModel: CalloutViewModel) {
        if let model = viewModel as? PlaceMarkModel {
            carNameLabel.text = model.driver.name
            fluelLabel.text = model.driver.fuel.description
            typeEngineLabel.text = model.driver.engineType
            exteriorLabel.text = model.driver.exterior
            interiorLabel.text = model.driver.interior
            addressLabel.text = model.driver.address
        }
    }
}
