//
//  UIViewController+Extension.swift
//  CanhTran
//
//  Created by Canh Tran on 2/27/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit 

extension UIViewController {
    
    class func instantiateFromStoryboard() -> Self
    {
        return instantiateFromStoryboardHelper(self, storyboardName: StoryBoardName.main)
    }
    
    class func instantiateFromStoryboard(_ storyboardName: String) -> Self
    {
        return instantiateFromStoryboardHelper(self, storyboardName: storyboardName)
    }
    
    
    fileprivate class func instantiateFromStoryboardHelper<T>(_ type: T.Type, storyboardName: String) -> T
    {
        var storyboardId = ""
        let components = "\(Swift.type(of: type))".components(separatedBy: ".")
        
        if components.count > 1
        {
            storyboardId = components[0]
        }
        let storyboad = UIStoryboard(name: storyboardName, bundle: nil)
        let controller = storyboad.instantiateViewController(withIdentifier: storyboardId) as! T
        
        return controller
    }
    
}
