//
//  Keebin_development_1UITests.swift
//  Keebin_development_1UITests
//
//  Created by Steffen Lefort on 01/02/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import XCTest

class Keebin_development_1UITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    

    func testAAllePages() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        let app = XCUIApplication()
        

        app.buttons["loginButton"].tap()
        
        let tabBarsQuery = app.tabBars
        tabBarsQuery.buttons["Klippekort"].tap()
        tabBarsQuery.buttons["Premium"].tap()
        tabBarsQuery.buttons["Kort"].tap()
        app.maps.containing(.other, identifier:"Sorgenfri Slotshave").element.swipeLeft()
        app.buttons["ic my location"].tap()
        tabBarsQuery.buttons["Hjem"].tap()
        let icMenuWhiteButton = app.navigationBars["Keebin_development_1.HomeView2"].buttons["ic menu white"]
        icMenuWhiteButton.tap()
        let logudButton = app.buttons["Logud"]
        logudButton.tap()
        
        
    }
    
    
    func testBMobilePay() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        
        
        
    }
    
   
    
    
}
