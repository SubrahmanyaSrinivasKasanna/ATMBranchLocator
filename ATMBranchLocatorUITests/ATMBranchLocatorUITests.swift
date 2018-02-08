//
//  ATMBranchLocatorUITests.swift
//  ATMBranchLocatorUITests
//
//  Created by Srinivas Kasanna on 2/6/18.
//  Copyright © 2018 asdf. All rights reserved.
//

import XCTest
// I can improve UI test cases if I would get time to work for this app
class ATMBranchLocatorUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    // To test UI flow for the search ATMBranch locator
    func testBranchATMSearchUI(){
        
        let app = XCUIApplication()
        sleep(10)
        let atmBranchLocationsElement = app.otherElements.containing(.navigationBar, identifier:"ATM/Branch Locations").element
        atmBranchLocationsElement.tap()

    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    
}
