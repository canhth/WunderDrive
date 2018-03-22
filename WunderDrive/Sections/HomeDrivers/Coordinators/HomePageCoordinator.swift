//
//  HomePageCoordinator.swift
//  WunderDrive
//
//  Created by Tran Hoang Canh on 21/3/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit

class HomePageCoordinator: Coordinator {
    
    init(window: UIWindow)
    {
        self.window = window
    }
    
    var window: UIWindow
    
    func startToLoadView()
    {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let listViewController = storyboard.instantiateViewController(withIdentifier: "MainTabbarViewController") as? MainTabbarViewController
        window.rootViewController = listViewController
    }
}
