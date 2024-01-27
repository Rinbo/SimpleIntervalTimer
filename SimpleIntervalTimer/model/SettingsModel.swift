import Foundation

struct SettingsModel {
    static let NUMBER_OF_ROUNDS_KEY: String = "NumberOfRounds"
    static let ROUND_DURATION_KEY: String = "RoundDuration"
    static let REST_DURATION_KEY: String = "RestDuration"
    static let WARNING_DURATION_KEY: String = "WarningDuration"
    
    static let DEFAULT_NUMBER_OF_ROUNDS: Int = 3
    static let DEFAULT_ROUND_DURATION: Duration = Duration.seconds(180)
    static let DEFAULT_REST_DURATION: Duration = Duration.seconds(60)
    static let DEFAULT_WARNING_DURATION: Duration = Duration.seconds(10)
    
    let numberOfRounds: Int
    let roundDuration: Duration
    let restDuration: Duration
    let warningDuration: Duration
    
    init(numberOfRounds: Int = 2, 
         roundDuration: Duration = Duration.seconds(5),
         restDuration: Duration = Duration.seconds(5),
         warningDuration: Duration = Duration.seconds(10)) {
        self.numberOfRounds = numberOfRounds
        self.roundDuration = roundDuration
        self.restDuration = restDuration
        self.warningDuration = warningDuration
    }
}
