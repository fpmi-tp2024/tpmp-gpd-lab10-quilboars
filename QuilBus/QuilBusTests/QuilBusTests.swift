//
//  QuilBusTests.swift
//  QuilBusTests
//
//  Created by Michael Romanov on 5/29/24.
//

import XCTest
@testable import QuilBus

class QuilBusTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func test_security_password_hash_valid() throws
    {
        let password = "1e_dg_tr75";
        let hashedPassword = String(password.hash);
        
        let isValid = PasswordComparer.Compare(coming: password, stored: hashedPassword);
        
        XCTAssertTrue(isValid)
    }
    
    func test_security_password_hash_invalid() throws
    {
        let password = "1e_dg_tr75";
        let hashedPassword = String(password.hash + 1);
        
        let isValid = PasswordComparer.Compare(coming: password, stored: hashedPassword);
        
        XCTAssertFalse(isValid);
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
