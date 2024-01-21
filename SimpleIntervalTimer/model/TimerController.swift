import Foundation
import SwiftUI
import Combine

class TimerController : ObservableObject{
    var settingsModel: SettingsModel
    
    @Published var roundBanner: String
    @ObservedObject var timerViewModel : TimerViewModel
    @Published var currentRound: Int = 1;
    @Published var isRestRound : Bool = false
    
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
            print("we are finished")
            SoundService.shared.playSound("finished")
            reset()
            return;
        }
        
        SoundService.shared.playSound("round-start-end")
        if !isRestRound && settingsModel.restDuration != Duration.zero {
            isRestRound = true;
            timerViewModel.reInit(currentValue: settingsModel.restDuration)
            print("We are going to rest round")
            return;
        }
        
        timerViewModel.reInit(currentValue: settingsModel.roundDuration)
        currentRound += 1;
        roundBanner = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        isRestRound = false
        print("We are moving to the next round")
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
}
