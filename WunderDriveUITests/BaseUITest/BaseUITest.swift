//
//  BaseUITest.swift
//  
//
//  Created by Canh Tran on 2/28/18.
//  Copyright © 2018 Tran Hoang Canh. All rights reserved.
//

import XCTest

class BaseUITest: XCTestCase {
    
    let app = XCUIApplication()
    let exists = NSPredicate(format: "exists == true")
    let nonExists = NSPredicate(format: "exists == false")
    let isHittable = NSPredicate(format: "hittable == true")
    let hasKeyboardFocus = NSPredicate(value: true)
    private let timeOut: TimeInterval = 10
    
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()
 
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func checkIfUIElementHasKeyboardFocus(_ element: XCUIElement) -> Bool {
        return (element.value(forKey: "hasKeyboardFocus") as? Bool) ?? false
    }
    
    func waitUntilElementExists(_ element: XCUIElement) {
        self.expectation(for: exists, evaluatedWith: element, handler: nil)
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func waitUntilElementExistsWithKeyboardFocus(_ element: XCUIElement) {
        self.expectation(for: hasKeyboardFocus , evaluatedWith: element) {
            return self.checkIfUIElementHasKeyboardFocus(element)
        }
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func waitUntilElementNonExists(_ element: XCUIElement) {
        self.expectation(for: nonExists, evaluatedWith: element, handler: nil)
        self.waitForExpectations(timeout: timeOut, handler: nil)
    }
    
    func inputTextToTextField(_ element: XCUIElement, text: String) {
        waitUntilElementExists(element)
        element.tap()
        element.clearAndEnterText(text)
    }
    
}
