import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @ObservedObject var controller: TimerController
    @ObservedObject var model: TimerViewModel
    
    var body: some View {
        CircularProgressBar(progress: calculateProgress()) {
            Text(controller.roundBanner)
                .font(.largeTitle)
                .accessibilityIdentifier("RoundInfoBanner")
                .offset(y: -95)
            
            Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
                .font(.system(size: 90))
                .foregroundColor(controller.state == TimerState.REST ? .gray : .primary)
                .accessibilityIdentifier("TimerValue")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: 300, height: 300)
        .padding(15)
    }
    
    private func calculateProgress() -> Double {
        let settingsModel = controller.settingsModel
        let roundDuration = controller.state == TimerState.REST ? settingsModel.restDuration : settingsModel.roundDuration
        return (roundDuration - model.currentValue) / roundDuration
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
