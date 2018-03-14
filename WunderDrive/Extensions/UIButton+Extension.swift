//
//  UIButton+Extension.swift
//  CanhTran
//
//  Created by Canh Tran on 2/27/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

extension UIButton {
     
    @IBInspectable var localizeKey: String {
        
        get {
            return ""
        } set {
            self.setTitle(NSLocalizedString(newValue, comment: ""), for: UIControlState())
        }
    }
    
}

