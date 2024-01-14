import SwiftUI

@main
struct SimpleIntervalTimerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(timerController: TimerController(settingsModel: SettingsModel()))
        }
    }
}
