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
                    
                    Button(action: { timerController.reset() }){
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
                        SettingsView(isPresented: $showingSettings, settingsModel: timerController.settingsModel)
                    }
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView(timerController: TimerController(settingsModel: SettingsModel()))
}
