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
                Text(controller.toast)
                    .font(.largeTitle)
                    .animation(.easeInOut)
                    .offset(y: 35.0)
                Spacer()
            }
            
            TimerView(controller: controller, model: timerViewModel)
                .padding(.bottom, 50)
            
            VStack {
                Spacer()
                HStack {
                    Button(action: { controller.reset() }){
                        Image(systemName: "arrow.clockwise")
                        .font(.system(size: 40)) }
                    .foregroundColor(.accentColor)
                    .accessibilityIdentifier("ResetButton")
                    
                    Spacer()
                    
                    Button(action: { controller.toggleActive() }) {
                        Image(systemName: timerViewModel.active ? "pause.circle.fill": "play.circle.fill")
                            .frame(width: 100, height: 100)
                            .font(.system(size: 100))
                            .background(Color(UIColor.systemBackground))
                            .scaledToFit()
                            .accessibilityIdentifier("PlayPauseButton")
                    }
                    .buttonStyle(.borderless)
                    .foregroundColor(.green)
                    .clipShape(Circle())
                    .transaction { transaction in
                        transaction.disablesAnimations = true
                    }
                    
                    Spacer()
                    
                    Button(action: { showingSettings = true }){
                        Image(systemName: "slider.horizontal.3")
                            .font(.system(size: 40))
                        
                    }
                    .foregroundColor(.accentColor)
                    .accessibilityIdentifier("SettingsButton")
                    .sheet(isPresented: $showingSettings) {
                        SettingsView(isPresented: $showingSettings, settingsModel: controller.settingsModel, callback: {(settingsModel: SettingsModel) in
                            controller.update(settingsModel: settingsModel)
                        })
                    }
                }
                .padding(.vertical, 15.0)
                .padding(.horizontal, 35.0)
            }
        }
        .background(getBackgroundColor())
    }
    
    private func getBackgroundColor() -> Color {
        switch (controller.state) {
        case .REST:
            return Color.gray.opacity(0.3)
        case .ROUND:
            return colorScheme == .dark ?  Color.green.opacity(0.2) : Color.green.opacity(0.1)
        case .INITIALIZED, .COMPLETED:
            return Color(UIColor.systemBackground)
        }
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
