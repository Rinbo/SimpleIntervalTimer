import SwiftUI

struct MainView: View {
    @ObservedObject var controller: TimerController
    @State private var showingSettings = false
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                if controller.isRestRound { Text("REST").font(.title) }
            }
            
            Text(controller.roundBanner).font(.largeTitle).padding(.bottom, -15.0)
            TimerView(model: controller.timerViewModel, isRestRound: controller.isRestRound)
            
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    
                    Button(action: {
                        controller.reset()
                        SoundService.shared.playSound("play-pause")
                    }){ Image(systemName: "arrow.clockwise").font(.system(size: 60)) }
                        .foregroundColor(.accentColor)
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }){
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 60))
                    }
                    .foregroundColor(.accentColor)
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(isPresented: $showingSettings, settingsModel: controller.settingsModel, callback: {(settingsModel: SettingsModel) in
                            controller.update(settingsModel: settingsModel)
                            controller.reset();
                        })
                    }
                    
                    Spacer()
                }
            }
        }.background(controller.isRestRound ? Color.gray.opacity(0.1) : Color(UIColor.systemBackground))
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
