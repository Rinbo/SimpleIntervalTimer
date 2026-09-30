import Foundation
import SwiftUI
import Combine

class TimerViewModel : ObservableObject {
    private static let PUBLISHING_INTERVAL_MS: Int = 100
    static let REINIT_DELAY_SECONDS: Double = 0.5
    
    @Published var currentValue : Duration
    @Published var active : Bool {
        didSet {
            UIApplication.shared.isIdleTimerDisabled = active
        }
    }
    
    var onTick: (_ previousValue: Duration, _ value: Duration) -> Void
    var onCompletion: () -> Void
    
    private var timer: Timer.TimerPublisher?
    private var timerCancellable: AnyCancellable?
    // Wall-clock time of the previous tick. Counting down by the real elapsed time (instead of
    // a fixed step per tick) keeps the timer correct if ticks are late or the app was suspended.
    private var lastTickDate: Date?
    
    init(startValue: Duration = Duration.seconds(10), onTick: @escaping (_ previousValue: Duration, _ value: Duration) -> Void, onCompletion: @escaping () -> Void) {
        self.currentValue = startValue
        self.active = false;
        self.onTick = onTick
        self.onCompletion = onCompletion
    }
    
    func initTimer() {
        lastTickDate = Date()
        timer = Timer.publish(every: TimeInterval(TimerViewModel.PUBLISHING_INTERVAL_MS) / 1000, on: .main, in: .common)
        timerCancellable = timer?.autoconnect().sink { _ in self.tick() }
    }
    
    func tick() {
        let now = Date()
        let elapsed = now.timeIntervalSince(lastTickDate ?? now)
        lastTickDate = now
        
        if currentValue <= Duration.zero {
            cancelTimer()
            onCompletion()
            return
        }
        
        if active {
            let previousValue = currentValue
            currentValue = max(Duration.zero, currentValue - Duration.seconds(elapsed))
            onTick(previousValue, currentValue)
        }
    }
    
    func cancelTimer() {
        timerCancellable?.cancel()
        timer = nil
        lastTickDate = nil
    }
    
    func reInit(currentValue: Duration, activate: Bool = true)  {
        self.currentValue = currentValue
        if activate {
            DispatchQueue.main.asyncAfter(deadline: .now() + TimerViewModel.REINIT_DELAY_SECONDS) { self.initTimer() }
        }
    }
}
