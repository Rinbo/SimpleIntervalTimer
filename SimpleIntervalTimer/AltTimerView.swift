import Foundation
import SwiftUI
import Combine

struct AltTimerView: View {
    @State private var countdownDuration = 5
    @State private var currentCountdown = 5
    @State private var timer: Timer.TimerPublisher?
    @State private var timerCancellable: AnyCancellable?
    @State private var active: Bool = false;
    @State private var firstTime: Bool = true;
    
    var body: some View {
        Text("\(currentCountdown) seconds remaining")
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
        timer = Timer.publish(every: 1, on: .main, in: .common)
        timerCancellable = timer?.autoconnect().sink { _ in tick() }
    }
    
    func reset() {
        firstTime = true;
        active = false;
        currentCountdown = countdownDuration
        timerCancellable?.cancel()
    }
    
    func tick() {
        print("Am I delayed?")
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
