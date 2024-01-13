import Foundation
import SwiftUI

struct TimerView: View {
    private static let DEFAULT_TIMER_COUNT : Duration = Duration.seconds(10);
    
    @State private var timerCount = DEFAULT_TIMER_COUNT
    @State private var active : Bool = false;
    private let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        Text(timerCount.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
            .font(.system(size: 100))
            .onReceive(timer) { _ in
                if timerCount <= Duration.zero {
                    timerCount = TimerView.DEFAULT_TIMER_COUNT
                    active = false
                    return
                }
                
                if active == true {
                    timerCount -= Duration.seconds(1)
                }
            }
            .onDisappear {
                self.timer.upstream.connect().cancel()
            }
        
        Button(active ? "Stop" : "Start") {
            active = !active
        }
        .font(.title)
        .buttonStyle(.borderedProminent)
        .padding()
        
        Button("Reset") {
            active = false
            timerCount = TimerView.DEFAULT_TIMER_COUNT
        }
        .font(.title2)
        .foregroundColor(.secondary)
    }
}

#Preview {
    MainView()
}
