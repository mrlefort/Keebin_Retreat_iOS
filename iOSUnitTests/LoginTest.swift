//
//  LoginTest.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 02/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import XCTest

@testable import Keebin_development_1

class LoginTest: XCTestCase {
    var login: LoginViewController?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        login = LoginViewController()
        
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        login = nil
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        login?.login(email: "tester@email.dk", password: "123"){loggedIn in
            XCTAssertTrue(loggedIn)
        }
    }
    
//    func testPerformanceExample() {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }
    
}
