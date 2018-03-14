//
//  String+Extension.swift
//  CanhTran
//
//  Created by Canh Tran on 2/27/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation


extension String {
    
    static func className(_ aClass: AnyClass) -> String {
        return NSStringFromClass(aClass).components(separatedBy: ".").last!
    }
   
    /**
     Check the string is the email
     
     :returns: ?true:flase
     */
    func isEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    
    // Validate password has at least 1 uppercase, 1 lowercase, 1 number and 1 special character and length > 8
    func validatePassword() -> Bool {
        guard self.count >= 8 else { return false }
        
        let capitalLetterRegEx  = ".*[A-Z]+.*"
        let texttest = NSPredicate(format:"SELF MATCHES %@", capitalLetterRegEx)
        guard texttest.evaluate(with: self) else { return false }
        
        let normalLetterRegEx  = ".*[a-z]+.*"
        let texttestNormal = NSPredicate(format:"SELF MATCHES %@", normalLetterRegEx)
        guard texttestNormal.evaluate(with: self) else { return false }
        
        let numberRegEx  = ".*[0-9]+.*"
        let texttest1 = NSPredicate(format:"SELF MATCHES %@", numberRegEx)
        guard texttest1.evaluate(with: self) else { return false }
        
        let specialCharacterRegEx  = ".*[!&^%$#@()/_*+-]+.*"
        let texttest2 = NSPredicate(format:"SELF MATCHES %@", specialCharacterRegEx)
        guard texttest2.evaluate(with: self) else { return false }
        
        return true
    }
    
    /// Get localized string
    var localized: String! {
        let localizedString = NSLocalizedString(self, comment: "")
        if self == localizedString {
            print("CANNOT FIND TRANSLATION FOR STRING \(self)")
        }
        return localizedString
    }
    
    func convertDateStringToCareemFormat() -> String {
        guard self.count > 0 else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        guard let date = dateFormatter.date(from: self) else { return "" }
        dateFormatter.dateFormat = "MMM dd yyyy"
        return  dateFormatter.string(from: date)
    }
}
