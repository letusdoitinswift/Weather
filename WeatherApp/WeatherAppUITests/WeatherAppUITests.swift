//
//  WeatherAppUITests.swift
//  WeatherAppUITests
//
//  Created by Manish Gupta on 10/18/24.
//

import XCTest

final class WeatherAppUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

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
    
    func testLocationPromoptAtLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        _ = addUIInterruptionMonitor(withDescription: "Location Permission Alert") { (alertElement) -> Bool in
            for element in 0..<alertElement.buttons.count - 1 {
                print("Button Label: \(alertElement.buttons.element(boundBy: element).label)")
            }
            return true
        }
    }
}
