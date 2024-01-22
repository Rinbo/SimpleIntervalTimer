import Foundation
import SwiftUI
import Combine

class TimerController : ObservableObject{
    let timerViewModel : TimerViewModel
    var settingsModel: SettingsModel
    
    @Published var roundBanner: String
    @Published var currentRound: Int = 1;
    @Published var isRestRound : Bool = false
    @Published var toast : String = ""
    
    init(settingsModel: SettingsModel){
        self.settingsModel = settingsModel
        self.roundBanner = TimerController.getDescription(1, settingsModel.numberOfRounds)
        
        self.timerViewModel = TimerViewModel(startValue: settingsModel.roundDuration, onCompletion: {})
        self.timerViewModel.onCompletion = { self.next() }
    }
    
    private static func getDescription(_ currentRound: Int, _ totalRounds: Int) -> String {
        return "Round \(currentRound) of \(totalRounds)"
    }
    
    func next() {
        if currentRound == settingsModel.numberOfRounds {
            SoundService.shared.playSound("finished")
            setToast(message: "Exercise Completed")
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) { self.clearToast() }
            reset()
            return;
        }
        
        SoundService.shared.playSound("round-start-end")
        if !isRestRound && settingsModel.restDuration != Duration.zero {
            setToast(message: "REST")
            isRestRound = true;
            timerViewModel.reInit(currentValue: settingsModel.restDuration)
            return;
        }
        
        clearToast()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration)
        currentRound += 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        isRestRound = false
    }
    
    func update(settingsModel: SettingsModel) {
        self.settingsModel = settingsModel
        saveSettingsModel(settingsModel)
    }
    
    func reset() {
        timerViewModel.cancelTimer()
        timerViewModel.reInit(currentValue: settingsModel.roundDuration, activate: false)
        currentRound = 1;
        isRestRound = false
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        timerViewModel.active = false
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
