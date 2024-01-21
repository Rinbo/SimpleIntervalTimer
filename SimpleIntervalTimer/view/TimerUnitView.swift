import Foundation
import SwiftUI
import Combine

struct TimerUnitView: View {
    @StateObject var model: TimerUnitViewModel
    var isResting: Bool
    
    var body: some View {
        Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
            .font(.system(size: 100))
            .foregroundColor(isResting ? .gray : .primary)
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
