import SwiftUI

struct MainView: View {
    @ObservedObject private var controller: TimerController
    @ObservedObject private var timerViewModel: TimerViewModel
    @State private var showingSettings: Bool = false
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.horizontalSizeClass) var sizeClass
    
    private var isRegular: Bool {
        sizeClass == .regular
    }
    
    init(controller: TimerController) {
        self.controller = controller
        self.timerViewModel = controller.timerViewModel
    }
    
    var body: some View {
        ZStack {
            getBackgroundColor()
                .ignoresSafeArea()
            
            VStack {
                VStack {
                    Spacer()
                    Text(controller.toast)
                        .font(isRegular ? .system(size: 60) : .largeTitle)
                        .animation(.easeInOut, value: controller.toast)
                        .offset(y: 25.0)
                    Spacer()
                }
                
                TimerView(controller: controller, model: timerViewModel)
                    .padding(.bottom, isRegular ? 80 : 45)
                
                VStack {
                    Spacer()
                    HStack {
                        Button(action: { controller.reset() }){
                            Image(systemName: "arrow.clockwise")
                            .font(.system(size: isRegular ? 60 : 40)) }
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("Reset")
                        .accessibilityIdentifier("ResetButton")
                        
                        Spacer()
                        
                        Button(action: { controller.toggleActive() }) {
                            Image(systemName: timerViewModel.active ? "pause.circle.fill": "play.circle.fill")
                                .frame(width: isRegular ? 150 : 100, height: isRegular ? 150 : 100)
                                .font(.system(size: isRegular ? 150 : 100))
                                .background(Color(UIColor.systemBackground))
                                .scaledToFit()
                                .accessibilityIdentifier("PlayPauseButton")
                        }
                        .buttonStyle(.borderless)
                        .accessibilityLabel(timerViewModel.active ? "Pause" : "Start")
                        .foregroundColor(.green)
                        .clipShape(Circle())
                        .transaction { transaction in
                            transaction.disablesAnimations = true
                        }
                        
                        Spacer()
                        
                        Button(action: { showingSettings = true }){
                            Image(systemName: "slider.horizontal.3")
                                .font(.system(size: isRegular ? 60 : 40))
                            
                        }
                        .foregroundColor(.accentColor)
                        .accessibilityLabel("Settings")
                        .accessibilityIdentifier("SettingsButton")
                        .sheet(isPresented: $showingSettings) {
                            SettingsView(isPresented: $showingSettings, settingsModel: controller.settingsModel, callback: {(settingsModel: SettingsModel) in
                                controller.update(settingsModel: settingsModel)
                            })
                        }
                    }
                    .padding(isRegular ? 60 : 35)
                    .frame(maxWidth: isRegular ? 800 : .infinity)
                }
            }
            .frame(maxWidth: isRegular ? 1000 : .infinity)
        }
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
