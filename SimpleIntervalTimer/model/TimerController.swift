import Foundation
import SwiftUI
import Combine

class TimerController : ObservableObject{
    private let settingsModel: SettingsModel
    @Published var currentTimeUnitViewModel : TimerUnitViewModel
    @Published var currentRound: Int = 1;
    @Published var isRestRound : Bool = false
    
    init(settingsModel: SettingsModel){
        self.settingsModel = settingsModel
        self.currentTimeUnitViewModel = TimerUnitViewModel(startValue: settingsModel.roundDuration, onCompletion: {})
        self.currentTimeUnitViewModel.onCompletion = { self.next() }
    }
    
    func next() {
        if currentRound == settingsModel.numberOfRounds {
            print("we are finished")
            currentTimeUnitViewModel.reInit(currentValue: settingsModel.roundDuration, activate: false)
            currentRound = 1;
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
        print("We are moving to the next round")
        
    }
    
}
