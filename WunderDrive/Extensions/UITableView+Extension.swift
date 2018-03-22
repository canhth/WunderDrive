//
//  UITableViewCell+Extension.swift
//  CanhTran
//
//  Created by Canh Tran on 2/28/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

public extension UITableView {
    
    func registerCellNib(_ cellClass: AnyClass) {
        let identifier = NSStringFromClass(cellClass).components(separatedBy: ".").last!
        let nib = UINib(nibName: identifier, bundle: nil)
        self.register(nib, forCellReuseIdentifier: identifier)
    }
    
}

