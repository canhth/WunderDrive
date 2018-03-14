//
//  Helper.swift
//  CanhTran
//
//  Created by Canh Tran on 2/27/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import UIKit
import KeychainAccess
import CT_RESTAPI

enum FontType: Int {
    case Default = 0, Small, Large
    
    var fount: UIFont {
        switch self {
        case .Default:
            return UIFont.systemFont(ofSize: 15)
        case .Small:
            return UIFont.systemFont(ofSize: 12)
        case .Large:
            return UIFont.systemFont(ofSize: 24)
        }
    }
    
    static func getFont(rawValue: Int) -> UIFont  {
        if let fontType = FontType(rawValue: rawValue) {
            return fontType.fount
        }
        return FontType.Default.fount
    }
}

class Helper {
    
    private static let keyChainService = "com.example.careem-token"
    
    static func getDataFromJSONFile(fileName: String, key: String) -> Data? {
        if let path = Bundle.main.path(forResource: fileName, ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? Dictionary<String, AnyObject>, let restaurants = jsonResult[key] as? [Any] {
                    return try JSONSerialization.data(withJSONObject: restaurants, options: [])
                }
            } catch {
                // handle error here
            }
        }
        return nil
    }
    
    static func saveFakeToken(tokenString: String) {
        let keychain = Keychain(service: keyChainService)
        keychain["userToken"] = tokenString
    }
    
    static func getFakeToken() -> Bool {
        let keychain = Keychain(service: keyChainService)
        if let token = keychain["userToken"] {
            return token.count > 0
        }
        return false
    }
    
    static func showAlertViewWith(error: CTNetworkErrorType) {
        if let viewController = UIApplication.topViewController() {
            let title = "Error \(error.errorCode)"
            var message = ""
            switch error {
            case let .errorMessage(_, _, errorMessage):
                message = errorMessage
                break
            default:
                break
            }
            
            let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            viewController.present(alert, animated: true, completion: nil)
        }
    }
    
}
