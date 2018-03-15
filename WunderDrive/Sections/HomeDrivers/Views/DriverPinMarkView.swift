//
//  DriverPinMarkView.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

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
