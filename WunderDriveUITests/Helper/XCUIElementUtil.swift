//
//  XCUIElementUtil.swift
//  
//
//  Created by Canh Tran on 3/1/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import Foundation
import XCTest

extension XCUIElement {
    
    func clearAndEnterText(_ text: String) -> Void {
        guard let stringValue = self.value as? String else {
            XCTFail("Tried to clear and enter text into a non string value")
            return
        }
        
        var deleteString: String = ""
        for _ in 0..<stringValue.count {
            deleteString += "\u{8}"
        }
        self.typeText(deleteString)
        
        self.typeText(text)
    }
    
    var displayed: Bool {
        guard self.exists && !frame.isEmpty else { return false }
        return XCUIApplication().windows.element(boundBy: 0).frame.contains(frame)
    }
    
    func forceTapElement() {
        if self.isHittable {
            self.tap()
        }
        else {
            let coordinate: XCUICoordinate = self.coordinate(withNormalizedOffset: CGVector(dx:0.0, dy:0.0))
            coordinate.tap()
        }
    }
    
}
