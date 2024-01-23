import Foundation
import SwiftUI
import Combine

class TimerViewModel : ObservableObject {
    private static let PUBLISHING_INTERVAL_MS: Int = 1000
    
    @Published var currentValue : Duration
    @Published var active : Bool
    
    var onCompletion: () -> Void
    private var timer: Timer.TimerPublisher?
    private var timerCancellable: AnyCancellable?
    
    init(startValue: Duration = Duration.seconds(10), onCompletion: @escaping () -> Void) {
        self.currentValue = startValue
        self.active = false;
        self.onCompletion = onCompletion
    }
    
    func initTimer() {
        timer = Timer.publish(every: TimeInterval(TimerViewModel.PUBLISHING_INTERVAL_MS) / 1000, on: .main, in: .common)
        timerCancellable = timer?.autoconnect().sink { _ in self.tick() }
    }
    
    func tick() {
        if currentValue <= Duration.zero {
            cancelTimer()
            onCompletion()
            return
        }
        
        if active {
            currentValue -= Duration.milliseconds(TimerViewModel.PUBLISHING_INTERVAL_MS);
        }
    }
    
    func cancelTimer() {
        timerCancellable?.cancel()
        timer = nil
    }
    
    func reInit(currentValue: Duration, activate: Bool = true)  {
        self.currentValue = currentValue
        if activate {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { self.initTimer() }
        }
    }
}
