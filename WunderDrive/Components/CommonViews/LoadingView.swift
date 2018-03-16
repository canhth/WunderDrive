//
//  LoadingView.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 15/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import SVProgressHUD

class LoaddingView: UIView {
    
    static private var hudCount: Int = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startLoadding() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            LoaddingView.hudCount += 1
            SVProgressHUD.setFadeInAnimationDuration(0.1)
            SVProgressHUD.setFadeOutAnimationDuration(0.1)
            SVProgressHUD.setDefaultMaskType(SVProgressHUDMaskType.none)
            SVProgressHUD.show()
            self.isHidden = false
        }
    }
    
    func stopLoadding() {
        DispatchQueue.main.async {
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            LoaddingView.hudCount -= 1
            if LoaddingView.hudCount <= 0 {
                LoaddingView.hudCount = 0
                SVProgressHUD.dismiss()
            }
            self.isHidden = true
        }
    }
}
