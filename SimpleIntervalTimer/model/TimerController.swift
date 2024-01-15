import Foundation
import SwiftUI
import Combine

class TimerController : ObservableObject{
    let settingsModel: SettingsModel
    
    @Published var description: String
    @Published var currentTimeUnitViewModel : TimerUnitViewModel
    @Published var currentRound: Int = 1;
    @Published var isRestRound : Bool = false
    
    init(settingsModel: SettingsModel){
        self.settingsModel = settingsModel
        self.description = TimerController.getDescription(1, settingsModel.numberOfRounds)
        
        self.currentTimeUnitViewModel = TimerUnitViewModel(startValue: settingsModel.roundDuration, onCompletion: {})
        self.currentTimeUnitViewModel.onCompletion = { self.next() }
    }
    
    private static func getDescription(_ currentRound: Int, _ totalRounds: Int) -> String {
        return "Round \(currentRound) of \(totalRounds)"
    }
    
    func next() {
        if currentRound == settingsModel.numberOfRounds {
            print("we are finished")
            reset()
            return;
        }
        
        if !isRestRound && settingsModel.restDuration != Duration.zero {
            isRestRound = true;
            currentTimeUnitViewModel.reInit(currentValue: settingsModel.restDuration)
            print("We are going to rest round")
            return;
        }
        
        currentTimeUnitViewModel.reInit(currentValue: settingsModel.roundDuration)
        currentRound += 1;
        description = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        isRestRound = false
        print("We are moving to the next round")
    }
    
    func reset() {
        currentTimeUnitViewModel.reInit(currentValue: settingsModel.roundDuration, activate: false)
        currentRound = 1;
        isRestRound = false
        description = TimerController.getDescription(currentRound, settingsModel.numberOfRounds)
        currentTimeUnitViewModel.active = false
    }
}
