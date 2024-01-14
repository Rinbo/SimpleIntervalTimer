import SwiftUI

struct MainView: View {
    
    var body: some View {
        VStack {
            TimerView(timerController: TimerController(settingsModel: SettingsModel()))
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: { print("reset") }){
                        Image(systemName: "arrow.clockwise")
                            .font(.system(size: 70))
                    }
                    .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Button(action: { print("reset") }){
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 70))
                    }
                    .foregroundColor(.accentColor)
                    
                    
                    Spacer()
                }
            }
        }
    }
}

#Preview {
    MainView()
}
