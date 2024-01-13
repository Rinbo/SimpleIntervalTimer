import SwiftUI

struct MainView: View {

    var body: some View {
        VStack {
           TimerView(timerController: TimerController(settingsModel: SettingsModel()))
        }
    }
}

#Preview {
    MainView()
}
