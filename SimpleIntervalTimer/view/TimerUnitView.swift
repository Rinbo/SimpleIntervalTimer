import Foundation
import SwiftUI
import Combine

struct TimerUnitView: View {
    @StateObject private var model: TimerUnitViewModel = TimerUnitViewModel(startValue: Duration.seconds(5), onCompletion: {
        print("I AM FINISHED")
    })
    
    
    var body: some View {
        Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
            .font(.system(size: 100))
            .padding()
        
        
        Button(model.active ? "Pause" : "Start") {
            model.toggleActive()
        }
        .buttonStyle(.borderedProminent)
        .font(.title)
        .padding()
    }
}

#Preview {
    MainView()
}
