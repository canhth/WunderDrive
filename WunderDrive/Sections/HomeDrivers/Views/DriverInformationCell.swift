//
//  DriverInformationCell.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

final class DriverInformationCell: UITableViewCell {

    // MARK: - IBOutlets
    @IBOutlet weak fileprivate var cellContentView: UIView!
    @IBOutlet weak fileprivate var carNameLabel: UILabel!
    @IBOutlet weak fileprivate var fluelLabel: UILabel!
    @IBOutlet weak fileprivate var typeEngineLabel: UILabel!
    @IBOutlet weak fileprivate var exteriorLabel: UILabel!
    @IBOutlet weak fileprivate var interiorLabel: UILabel!
    @IBOutlet weak fileprivate var addressLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellContentView.layer.applySketchShadow(color: UIColor.shadowColor, alpha: 0.5, x: 0, y: 5, blur: 12, spread: 0)
        
    }
    
    // MARK: - Funcs
    func setupCellWithModel(model: Driver) {
        
    }
    
}
