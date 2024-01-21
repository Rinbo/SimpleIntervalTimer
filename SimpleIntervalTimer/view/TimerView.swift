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
                .frame(width: 100, height: 100)
                .font(.system(size: 100))
                .background(Color(UIColor.systemBackground))
                .scaledToFit()
            
        }
        .buttonStyle(.borderless)
        .foregroundColor(.green)
        .clipShape(Circle())
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
