import Foundation
import SwiftUI
import Combine

enum TimerState {
    case INITIALIZED
    case ROUND
    case REST
    case COMPLETED
}

class TimerController : ObservableObject{
    let timerViewModel : TimerViewModel
    var settingsModel: SettingsModel
    
    @Published var roundBanner: String
    @Published var currentRound: Int = 1;
    @Published var state : TimerState = TimerState.INITIALIZED
    @Published var toast : String = ""
    
    private let soundService: SoundService
    private let liveActivityService: LiveActivityService
    
    init(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        self.roundBanner = TimerController.getDescription(1, settingsModel.numberOfRounds)
        
        self.timerViewModel = TimerViewModel(startValue: settingsModel.roundDuration, onTick: {_, _ in }, onCompletion: {})
        self.soundService = SoundService()
        self.liveActivityService = LiveActivityService()
    }
    
    init(settingsModel: SettingsModel, timerViewModel: TimerViewModel, soundService: SoundService, liveActivityService: LiveActivityService) {
        self.settingsModel = settingsModel
        self.roundBanner = TimerController.getDescription(1, settingsModel.numberOfRounds)
        
        self.timerViewModel = timerViewModel
        self.soundService = soundService
        self.liveActivityService = liveActivityService
    }
    
    private static func getDescription(_ currentRound: Int, _ totalRounds: Int) -> String {
        return "\(currentRound) / \(totalRounds)"
    }
    
    func toggleActive() {
        if (state == TimerState.INITIALIZED) {
            soundService.playDing()
            self.timerViewModel.onCompletion = { self.onRoundComplete() }
            self.timerViewModel.onTick = {previousValue, value in self.onTick(previousValue: previousValue, value: value)}
            timerViewModel.initTimer()
            state = TimerState.ROUND
        } else {
            soundService.playPause()
        }
        
        timerViewModel.active = !timerViewModel.active
        
        if timerViewModel.active {
            soundService.startBackgroundKeepAlive()
        } else {
            soundService.stopBackgroundKeepAlive()
        }
        updateLiveActivity()
    }
    
    func update(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        saveSettingsModel(settingsModel)
        clearToast()
        resetTimer()
    }
    
    func reset() {
        soundService.playBeep()
        clearToast()
        resetTimer()
    }
    
    private func resetTimer() {
        timerViewModel.cancelTimer()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration, activate: false)
        currentRound = 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        timerViewModel.active = false
        soundService.stopBackgroundKeepAlive()
        liveActivityService.end()
        state = TimerState.INITIALIZED
    }
    
    private func onTick(previousValue: Duration, value: Duration) {
        if state == TimerState.ROUND
            && previousValue > settingsModel.warningDuration
            && value <= settingsModel.warningDuration
            && settingsModel.warningDuration > Duration.zero
        { soundService.playClap() }
    }
    
    private func onRoundComplete() {
        if (settingsModel.numberOfRounds == 1) {
            onFinished()
            return
        }
        
        if settingsModel.restDuration == Duration.zero {
            onRestComplete()
            return
        }
        
        soundService.playDing()
        setToast(message: "REST")
        timerViewModel.reInit(currentValue: settingsModel.restDuration)
        self.timerViewModel.onCompletion = { self.onRestComplete() }
        state = TimerState.REST
        updateLiveActivity(startDelay: TimerViewModel.REINIT_DELAY_SECONDS)
    }
    
    private func onRestComplete() {
        soundService.playDing()
        clearToast()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration)
        currentRound += 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        self.timerViewModel.onCompletion = { self.currentRound == self.settingsModel.numberOfRounds ? self.onFinished() : self.onRoundComplete()}
        state = TimerState.ROUND
        updateLiveActivity(startDelay: TimerViewModel.REINIT_DELAY_SECONDS)
    }
    
    private func onFinished() {
        soundService.playDingDing()
        state = TimerState.COMPLETED
        setToast(message: "Exercise Completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.clearToast() }
        resetTimer()
    }
    
    // startDelay: a new round or rest only starts counting after a short pause (see TimerViewModel.reInit).
    private func updateLiveActivity(startDelay: TimeInterval = 0) {
        let isRest = state == TimerState.REST
        let remaining = timerViewModel.currentValue / Duration.seconds(1)
        let phaseDuration = (isRest ? settingsModel.restDuration : settingsModel.roundDuration) / Duration.seconds(1)
        
        liveActivityService.update(IntervalTimerAttributes.ContentState(
            isRest: isRest,
            currentRound: currentRound,
            totalRounds: settingsModel.numberOfRounds,
            phaseDuration: phaseDuration,
            endDate: Date().addingTimeInterval(startDelay + remaining),
            pausedRemaining: timerViewModel.active ? nil : remaining))
    }
    
    private func saveSettingsModel(_ settingsModel: SettingsModel) {
        let defaults = UserDefaults.standard
        
        defaults.set(settingsModel.numberOfRounds, forKey: SettingsModel.NUMBER_OF_ROUNDS_KEY)
        defaults.set(settingsModel.roundDuration.components.seconds, forKey: SettingsModel.ROUND_DURATION_KEY)
        defaults.set(settingsModel.restDuration.components.seconds, forKey: SettingsModel.REST_DURATION_KEY)
        defaults.set(settingsModel.warningDuration.components.seconds, forKey: SettingsModel.WARNING_DURATION_KEY)
    }
    
    private func setToast(message: String) {
        self.toast = message
    }
    
    private func clearToast() {
        self.toast = ""
    }
}
