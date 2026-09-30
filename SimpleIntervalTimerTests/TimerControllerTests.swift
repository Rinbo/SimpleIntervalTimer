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
    var playClapCalled = false
    var playPauseCalled = false
    
    override func playDing() {
        playDingCalled = true
    }
    
    override func playBeep() {
        playBeepCalled = true
    }
    
    override func playClap() {
        playClapCalled = true
    }
    
    override func playPause() {
        playPauseCalled = true
    }
}

class LiveActivityServiceMock: LiveActivityService {
    var lastState: IntervalTimerAttributes.ContentState?
    var endCalled = false
    
    override func update(_ state: IntervalTimerAttributes.ContentState) {
        lastState = state
    }
    
    override func end() {
        endCalled = true
    }
}

final class TimerControllerTests: XCTestCase {
    
    func testToggleActive() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
        
        timerController.toggleActive()
        
        XCTAssertTrue(soundServiceMock.playDingCalled, "Sound service should play a ding sound")
        XCTAssertTrue(timerViewModelMock.initTimerCalled, "Timer should be initialized")
        XCTAssertEqual(timerController.state, TimerState.ROUND, "Timer state should be updated to ROUND")
        XCTAssertTrue(timerViewModelMock.active, "Active flag should be set to true")
    }
    
    func testUpdate() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
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
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel()
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
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
    
    func testPauseSound() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let timerController = TimerController(settingsModel: SettingsModel(), timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
        
        timerController.toggleActive()
        XCTAssertFalse(soundServiceMock.playPauseCalled, "Starting the timer should not play the pause sound")
        
        timerController.toggleActive()
        XCTAssertTrue(soundServiceMock.playPauseCalled, "Pausing should play the pause sound")
        XCTAssertFalse(timerViewModelMock.active, "Timer should be paused")
        
        soundServiceMock.playPauseCalled = false
        timerController.toggleActive()
        XCTAssertTrue(soundServiceMock.playPauseCalled, "Resuming should play the pause sound")
        XCTAssertTrue(timerViewModelMock.active, "Timer should be running again")
    }
    
    func testWarningSoundWhenCrossingWarningDuration() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel(warningDuration: Duration.seconds(10))
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
        timerController.toggleActive()
        
        timerViewModelMock.onTick(Duration.milliseconds(10_150), Duration.milliseconds(10_050))
        XCTAssertFalse(soundServiceMock.playClapCalled, "Warning should not sound before the warning duration")
        
        timerViewModelMock.onTick(Duration.milliseconds(10_050), Duration.milliseconds(9_950))
        XCTAssertTrue(soundServiceMock.playClapCalled, "Warning should sound when the warning duration is crossed")
    }
    
    func testWarningSoundWhenJumpingPastWarningDuration() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let soundServiceMock = SoundServiceMock()
        let settingsModel = SettingsModel(warningDuration: Duration.seconds(10))
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: soundServiceMock, liveActivityService: LiveActivityServiceMock())
        timerController.toggleActive()
        
        timerViewModelMock.onTick(Duration.seconds(12), Duration.seconds(8))
        XCTAssertTrue(soundServiceMock.playClapCalled, "Warning should sound even if a late tick skips past the warning duration")
    }
    
    func testLiveActivity() {
        let timerViewModelMock = TimerViewModelMock(startValue: SettingsModel.DEFAULT_ROUND_DURATION, onTick: {_, _ in }, onCompletion: {})
        let liveActivityMock = LiveActivityServiceMock()
        let settingsModel = SettingsModel(numberOfRounds: 3)
        let timerController = TimerController(settingsModel: settingsModel, timerViewModel: timerViewModelMock, soundService: SoundServiceMock(), liveActivityService: liveActivityMock)
        
        timerController.toggleActive()
        XCTAssertEqual(liveActivityMock.lastState?.currentRound, 1)
        XCTAssertEqual(liveActivityMock.lastState?.totalRounds, 3)
        XCTAssertEqual(liveActivityMock.lastState?.isRest, false)
        XCTAssertEqual(liveActivityMock.lastState?.isPaused, false, "Live activity should count down while running")
        
        timerController.toggleActive()
        XCTAssertEqual(liveActivityMock.lastState?.isPaused, true, "Live activity should freeze while paused")
        
        timerController.reset()
        XCTAssertTrue(liveActivityMock.endCalled, "Live activity should end on reset")
    }
}
