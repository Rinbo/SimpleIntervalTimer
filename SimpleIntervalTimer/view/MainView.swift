import SwiftUI

struct MainView: View {
    @StateObject var timerController: TimerController
    @State private var showingSettings = false
    
    var body: some View {
        VStack {
            TimerView(timerController: timerController)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        timerController.reset()
                        SoundService.shared.playSound("play-pause")
                    }){
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 60))
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }){
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 60))
                    }
                    .foregroundColor(.accentColor)
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(isPresented: $showingSettings, settingsModel: timerController.settingsModel, callback: {(settingsModel: SettingsModel) in
                            timerController.update(settingsModel: settingsModel)
                            timerController.reset();
                        })
                    }
                    
                    Spacer()
                }
            }
        }.background(timerController.isRestRound ? Color.gray.opacity(0.1) : Color(UIColor.systemBackground))
    }
}

#Preview {
    MainView(timerController: TimerController(settingsModel: SettingsModel()))
}
