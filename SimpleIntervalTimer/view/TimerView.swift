import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @ObservedObject var model: TimerViewModel
    var isRestRound: Bool
    
    var body: some View {
        Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
            .font(.system(size: 100))
            .foregroundColor(isRestRound ? .gray : .primary)
            .padding()
        
        
        Button(action: { model.toggleActive() }) {
            Image(systemName: model.active ? "pause.circle.fill": "play.circle.fill")
                .font(.system(size: 100))
        }
        .buttonStyle(.borderless)
        .foregroundColor(.green)
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
