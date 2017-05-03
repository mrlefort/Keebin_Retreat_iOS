//
//  TokensTest.swift
//  Keebin_development_1
//
//  Created by Steffen Lefort on 02/05/2017.
//  Copyright © 2017 Keebin. All rights reserved.
//

import XCTest

@testable import Keebin_development_1

class TokensTest: XCTestCase {
    var login: LoginViewController?
    var aToken: String?
    var reToken: String?
    var brandsArray: [AnyObject]?
    var logout: HomeView2Controller?
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
        login = LoginViewController()
        logout = HomeView2Controller()
        self.aToken = ""
        self.reToken = ""
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
        logout?.logOut()
        logout = nil
        login = nil
        self.aToken = nil
        self.reToken = nil
        self.brandsArray = nil
        

    }
    
    func testALoginSetup() {

        let expectations = expectation(description: "Login Succeeds")
        
        login?.login(email: "tester@email.dk", password: "123"){loggedIn in
            
            if(loggedIn){
                expectations.fulfill()
            } else {
                XCTFail()
            }
            
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    func testBTokens() {
        let expectations = expectation(description: "Get tokens from DB Succeeds")
        
        getTokensFromDB(){tokens in
            if(!tokens.isEmpty){
                self.aToken = tokens["accessToken"]!
                self.reToken = tokens["refreshToken"]!
                expectations.fulfill()
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
    
    
    
    func testCGetBrands() {

        getAllCoffeeBrands(accessToken: self.aToken!, refreshToken: self.reToken!)
        
        
        let expectations = expectation(description: "Get Brands from DB Succeeds")
        
        getCoffeeBrandsFromDB(){brands in
            if(!brands.isEmpty){
                self.brandsArray = brands
                for each in self.brandsArray!{
                    let a = each.value(forKey: "brandName")
                    print("brandName: \(a as! String)")
                }
                expectations.fulfill()
            } else {
                XCTFail()
            }
        }
        waitForExpectations(timeout: 5, handler: nil)
        
    }
        
        
       

}


