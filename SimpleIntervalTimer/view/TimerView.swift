import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @ObservedObject var controller: TimerController
    @ObservedObject var model: TimerViewModel
    @Environment(\.horizontalSizeClass) var sizeClass
    
    private var isRegular: Bool {
        sizeClass == .regular
    }
    
    private var timerSize: CGFloat {
        isRegular ? 500 : 300
    }
    
    var body: some View {
        CircularProgressBar(progress: calculateProgress(), lineWidth: isRegular ? 24 : 18) {
            Text(controller.roundBanner)
                .font(isRegular ? .system(size: 48, weight: .bold) : .largeTitle)
                .accessibilityIdentifier("RoundInfoBanner")
                .offset(y: isRegular ? -150 : -95)
            
            Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
                .font(.system(size: isRegular ? 150 : 90))
                .monospacedDigit()
                .foregroundColor(controller.state == TimerState.REST ? .gray : .primary)
                .accessibilityIdentifier("TimerValue")
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .frame(width: timerSize, height: timerSize)
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
