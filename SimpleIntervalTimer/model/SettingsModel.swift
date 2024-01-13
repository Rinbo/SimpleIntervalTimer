import Foundation

struct SettingsModel {
    let numberOfRounds: Int
    let roundDuration: Duration
    let restDuration: Duration
    let warningDuration: Duration
    
    init(numberOfRounds: Int = 3, 
         roundDuration: Duration = Duration.seconds(5),
         restDuration: Duration = Duration.seconds(5),
         warningDuration: Duration = Duration.seconds(0)) {
        self.numberOfRounds = numberOfRounds
        self.roundDuration = roundDuration
        self.restDuration = restDuration
        self.warningDuration = warningDuration
    }
}
