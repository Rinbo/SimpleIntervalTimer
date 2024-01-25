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
    
    init(settingsModel: SettingsModel){
        self.settingsModel = settingsModel
        self.roundBanner = TimerController.getDescription(1, settingsModel.numberOfRounds)
        
        self.timerViewModel = TimerViewModel(startValue: settingsModel.roundDuration, onCompletion: {})
    }
    
    private static func getDescription(_ currentRound: Int, _ totalRounds: Int) -> String {
        return "Round \(currentRound) of \(totalRounds)"
    }
    
    func toggleActive() {
        if (state == TimerState.INITIALIZED) {
            SoundService.shared.playSound("round-start-end2")
            self.timerViewModel.onCompletion = { self.onRoundComplete() }
            timerViewModel.initTimer()
            state = TimerState.ROUND
        }
        
        timerViewModel.active = !timerViewModel.active
    }
    
    func update(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        saveSettingsModel(settingsModel)
    }
    
    func reset() {
        timerViewModel.cancelTimer()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration, activate: false)
        currentRound = 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        timerViewModel.active = false
        state = TimerState.INITIALIZED
    }
    
    private func onRoundComplete() {
        if settingsModel.restDuration == .zero {
            onRestComplete()
            return
        }
        SoundService.shared.playSound("round-start-end2")
        setToast(message: "REST")
        timerViewModel.reInit(currentValue: settingsModel.restDuration)
        self.timerViewModel.onCompletion = { self.onRestComplete() }
        state = TimerState.REST
    }
    
    private func onRestComplete() {
        SoundService.shared.playSound("round-start-end2")
        clearToast()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration)
        currentRound += 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        self.timerViewModel.onCompletion = { self.currentRound == self.settingsModel.numberOfRounds ? self.onFinished() : self.onRoundComplete()}
        state = TimerState.ROUND
    }
    
    private func onFinished() {
        SoundService.shared.playSound("finished2")
        state = TimerState.COMPLETED
        setToast(message: "Exercise Completed")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.clearToast() }
        reset()
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
