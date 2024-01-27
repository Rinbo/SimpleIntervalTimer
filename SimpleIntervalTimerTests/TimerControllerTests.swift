import XCTest
@testable import SimpleIntervalTimer

class MockTimerViewModel: TimerViewModel {
    var initTimerCalled = false

    override func initTimer() {
        initTimerCalled = true
    }
}

class MockSoundService: SoundService {
    var playDingCalled = false

    override func playDing() {
        playDingCalled = true
    }
}

class TimerControllerTests: XCTestCase {

    func testToggleActive() {
        let mockTimerViewModel = MockTimerViewModel(startValue: Duration.seconds(10), onTick: {value in }, onCompletion: {})
        let mockSoundService = MockSoundService()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: mockTimerViewModel, soundService: mockSoundService)

        timerController.toggleActive()

        XCTAssertTrue(mockSoundService.playDingCalled, "Sound service should play a ding sound")
        XCTAssertTrue(mockTimerViewModel.initTimerCalled, "Timer should be initialized")
        XCTAssertEqual(timerController.state, TimerState.ROUND, "Timer state should be updated to ROUND")
    }
}
