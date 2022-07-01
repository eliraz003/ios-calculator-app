//
//  calcUITests.swift
//  calcUITests
//
//  Created by Eliraz Atia on 27/03/2022.
//

import XCTest

class calcUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        XCUIDevice.shared.orientation = .portrait
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()
        
        func evaluateResults(expected: String) -> Bool {
            let res = app.otherElements["total_row"].staticTexts.matching(identifier: "total_label").firstMatch
            return (res.label == expected)
        }
        
        func pressClear() {
            // Tap Clear
            app.otherElements["clear"].tap()
            
            // Assert That It Works
            XCTAssert(
                evaluateResults(expected: "0"),
                "Results should be empty")
        }
        
        /**
         Test a basic integer value
         */
        
        // Tap Buttons
        app.otherElements["2"].tap()
        app.otherElements["1"].tap()
        
        // Assert Result
        XCTAssert(
            evaluateResults(expected: "21"),
            "Results should equal 21")
        
        // Clear Input
        pressClear()
        
        
        /**
         Test a basic decimal value
         */
        
        // Tap Buttons
        app.staticTexts["1"].tap()
        app.staticTexts["0"].tap()
        app.staticTexts["3"].tap()
        app.staticTexts["."].tap()
        app.staticTexts["5"].tap()
        app.staticTexts["2"].tap()
        
        // Assert Value
        XCTAssert(
            evaluateResults(expected: "103.52"),
            "Results should be 103.52")
        
        // Press Clear
        pressClear()
        
        
        
        /**
         Test a case where the user presses more than the allowed number of characters
         */
        
        
        
        /**
         Test a case where the user presses 3 characters then removes 4
         */
        
        
        /**
         Clear and set standard input
         */
        
        /**
         Press the add operation
         */
        
        /**
         Type a long input
         */
        
        /**
         Press the remove operation
         */
        
        /**
         Press the first input container and change it's value and change to minus operation
         */
        
        /**
         Swipe keypad over to scientific mode
         */
        
        /**
         Swipe keypad back to standard mode
         */
        
        /**
         Swipe back to scientific mode and calculate 4PI
         */
        
        
        
        // Press Add
        app.otherElements["plus"].tap()
        
        app.staticTexts["1"].tap()
        app.staticTexts["0"].tap()
        
        XCTAssert(
            evaluateResults(expected: "113.52"),
            "Results should be 103.52")
        
        
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testLaunchPerformance() throws {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, watchOS 7.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTApplicationLaunchMetric()]) {
                XCUIApplication().launch()
            }
        }
    }
}
