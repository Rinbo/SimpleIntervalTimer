import SwiftUI

struct MainView: View {
    @ObservedObject private var controller: TimerController
    @ObservedObject private var timerViewModel: TimerViewModel
    @State private var showingSettings: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    init(controller: TimerController) {
        self.controller = controller
        self.timerViewModel = controller.timerViewModel
    }
    
    var body: some View {
        VStack {
            VStack {
                Spacer()
                Text(controller.toast).font(.title).animation(.easeInOut)
            }
            
            Text(controller.roundBanner).font(.largeTitle).padding(.bottom, -15.0)
            TimerView(controller: controller, model: timerViewModel)
            
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
                }.padding(.bottom, 15)
            }
        }.background(getBackgroundColor())
    }
    
    func getBackgroundColor() -> Color {
        if (controller.isRestRound) { return colorScheme == .dark ?  Color.gray.opacity(0.3): Color.gray.opacity(0.1)}
        if (timerViewModel.active) { return colorScheme == .dark ?  Color.green.opacity(0.2): Color.green.opacity(0.08)}
        return  Color(UIColor.systemBackground)
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
