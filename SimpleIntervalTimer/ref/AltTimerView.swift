import Foundation
import SwiftUI
import Combine

struct AltTimerView: View {
    @State private var countdownDuration = 50
    @State private var currentCountdown = 50
    @State private var timer: Timer.TimerPublisher?
    @State private var timerCancellable: AnyCancellable?
    @State private var active: Bool = false;
    @State private var firstTime: Bool = true;
    
    var body: some View {
        Text("\(currentCountdown / 10) seconds remaining")
            .font(.system(size: 30))
            .padding()
           
        
        Button(active ? "Stop" : "Start") {
            if firstTime {
                firstTime = false
                startTimerForTheFirstTime()
            }
            
            active = !active
        }
        .buttonStyle(.borderedProminent)
        .font(.title)
        .padding()
        
        Button("Reset") {
            reset()
        }
        .foregroundColor(.secondary)
        .font(.title2)
    }
    
    func startTimerForTheFirstTime() {
        timer = Timer.publish(every: 0.1, on: .main, in: .common)
        timerCancellable = timer?.autoconnect().sink { _ in tick() }
    }
    
    func reset() {
        firstTime = true;
        active = false;
        currentCountdown = countdownDuration
        timerCancellable?.cancel()
    }
    
    func tick() {
        if currentCountdown <= 0 {
            reset()
            return
        }
        
        if active {
            currentCountdown -= 1;
        }
    }
}

#Preview {
    MainView()
}
