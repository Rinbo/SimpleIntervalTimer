import XCTest

final class SimpleIntervalTimerUITestsLaunchTests: XCTestCase {
    
    override class var runsForEachTargetApplicationUIConfiguration: Bool {
        true
    }
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }
    
    func testLaunch() throws {
        let app = XCUIApplication()
        app.launch()
        
        takeScreeshot(app, "Launch Screen Startup")
        
        XCTAssert(app.staticTexts["RoundInfoBanner"].exists)
        XCTAssert(app.staticTexts["TimerValue"].exists)
        XCTAssert(app.buttons["PlayPauseButton"].exists)
        XCTAssert(app.buttons["ResetButton"].exists)
        XCTAssert(app.buttons["SettingsButton"].exists)
        
        app.buttons["SettingsButton"].tap()
        takeScreeshot(app, "Setting View")
        
        XCTAssert(app.staticTexts["RoundDurationTitle"].exists)
        XCTAssert(app.staticTexts["NumberOfRoundsTitle"].exists)
        XCTAssert(app.staticTexts["RestDurationTitle"].exists)
        XCTAssert(app.staticTexts["EndOfRoundAlertTitle"].exists)
        XCTAssert(app.pickers["RoundDurationPicker"].exists)
        XCTAssert(app.pickers["NumberOfRoundsPicker"].exists)
        XCTAssert(app.pickers["RestDurationPicker"].exists)
        
        XCTAssert(app.buttons["SaveSettingsButton"].exists)
        
        app.buttons["SaveSettingsButton"].tap()
        
        takeScreeshot(app, "Launch Screen After Settings")
    }
    
    private func takeScreeshot(_ app: XCUIApplication,_ name: String) {
        let attachment = XCTAttachment(screenshot: app.screenshot())
        attachment.name = name
        attachment.lifetime = .keepAlways
        add(attachment)
    }
}
