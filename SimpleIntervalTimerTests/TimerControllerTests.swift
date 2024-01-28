import XCTest
@testable import SimpleIntervalTimer

class TimerViewModelMock: TimerViewModel {
    var initTimerCalled = false
    var cancelTimerCalled = false
    var reinitCalled = false
    
    override func initTimer() {
        initTimerCalled = true
    }
    
    override func cancelTimer() {
        cancelTimerCalled = true
    }
    
    override func reInit(currentValue: Duration, activate: Bool = true) {
        reinitCalled = true
    }
}

class SoundServiceMock: SoundService {
    var playDingCalled = false
    var playBeepCalled = false
    
    override func playDing() {
        playDingCalled = true
    }
    
    override func playBeep() {
        playBeepCalled = true
    }
}

final class TimerControllerTests: XCTestCase {
    
    func testToggleActive() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {value in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock)
        
        timerController.toggleActive()
        
        XCTAssertTrue(soundServiceMock.playDingCalled, "Sound service should play a ding sound")
        XCTAssertTrue(timerViewModelMock.initTimerCalled, "Timer should be initialized")
        XCTAssertEqual(timerController.state, TimerState.ROUND, "Timer state should be updated to ROUND")
        XCTAssertTrue(timerViewModelMock.active, "Active flag should be set to true")
    }
    
    func testUpdate() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {value in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock)
        timerController.state = TimerState.ROUND
        timerController.currentRound = 42
        timerViewModelMock.active = true
        
        
        let updatedSettingsModel = SettingsModel(numberOfRounds: 50);
        timerController.update(settingsModel: updatedSettingsModel)
        
        XCTAssertTrue(timerViewModelMock.cancelTimerCalled, "Timer should be cancelled")
        XCTAssertEqual(timerController.state, TimerState.INITIALIZED, "Timer state should be updated to INITIALIZED")
        XCTAssertFalse(timerViewModelMock.active, "Active flag should be set to false")
        XCTAssertEqual(timerController.currentRound, 1, "Current round should be reset to 1")
        XCTAssertEqual(timerController.settingsModel.numberOfRounds, 50)
    }
    
    func testReset() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {value in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock)
        timerController.state = TimerState.ROUND
        timerController.currentRound = 42
        timerViewModelMock.active = true
        
        timerController.reset()
        
        XCTAssertTrue(timerViewModelMock.reinitCalled, "Timer should be re-initialized")
        XCTAssertEqual(timerController.state, TimerState.INITIALIZED, "Timer state should be updated to INITIALIZED")
        XCTAssertFalse(timerViewModelMock.active, "Active flag should be set to false")
        XCTAssertEqual(timerController.currentRound, 1, "Current round should be reset to 1")
        XCTAssertTrue(soundServiceMock.playBeepCalled, "Beep sound should have called")
    }
}
