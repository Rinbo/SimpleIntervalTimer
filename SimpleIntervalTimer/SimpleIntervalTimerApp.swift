import SwiftUI

@main
struct SimpleIntervalTimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(controller: TimerController(settingsModel: loadSavedSettingsModel()))
        }
    }
    
    private func loadSavedSettingsModel() -> SettingsModel {
        return SettingsModel(
            numberOfRounds: loadNumberOfRounds(),
            roundDuration: loadDuration(SettingsModel.ROUND_DURATION_KEY, SettingsModel.DEFAULT_ROUND_DURATION),
            restDuration: loadDuration(SettingsModel.REST_DURATION_KEY, SettingsModel.DEFAULT_REST_DURATION),
            warningDuration: loadDuration(SettingsModel.WARNING_DURATION_KEY, SettingsModel.DEFAULT_WARNING_DURATION))
    }
    
    private func loadDuration(_ key: String,_ defaultDuration: Duration) -> Duration {
        let seconds: Double = UserDefaults.standard.double(forKey: key)
        return seconds != 0 ? Duration.seconds(seconds) : defaultDuration
    }
    
    private func loadNumberOfRounds() -> Int {
        let rounds = UserDefaults.standard.integer(forKey: SettingsModel.NUMBER_OF_ROUNDS_KEY)
        return rounds != 0 ? rounds : SettingsModel.DEFAULT_NUMBER_OF_ROUNDS
    }
}
