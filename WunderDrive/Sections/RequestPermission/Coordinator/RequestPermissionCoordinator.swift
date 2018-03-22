//
//  RequestPermissionCoordinator.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 21/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

protocol RequestPermissionDelegate: class {
    func locationAuthorizedDidChange(isAuthorized: Bool)
}

class RequestPermissionCoordinator: Coordinator {
    
    var delegate : RequestPermissionDelegate!
    
    let window: UIWindow
    
    init(window: UIWindow)
    {
        self.window = window
    }
    
    func startToLoadView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vc = storyboard.instantiateViewController(withIdentifier: "RequestPermissionViewController") as? RequestPermissionViewController {
            vc.delegate = self
            window.rootViewController = vc
        }
    }
}

extension RequestPermissionCoordinator : RequestPermissionViewControllerDelegate {
    
    func didAuthorizedAfterShowedViewController() {
        self.delegate.locationAuthorizedDidChange(isAuthorized: true)
    }
}
