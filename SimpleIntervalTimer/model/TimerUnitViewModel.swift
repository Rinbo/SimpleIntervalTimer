import Foundation
import SwiftUI
import Combine

class TimerUnitViewModel : ObservableObject {
    private static let PUBLISHING_INTERVAL_MS: Int = 100
    
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
    
    func toggleActive() {
        active = !active
        
        if (timer == nil) {
            timer = Timer.publish(every: TimeInterval(TimerUnitViewModel.PUBLISHING_INTERVAL_MS) / 1000, on: .main, in: .common)
            timerCancellable = timer?.autoconnect().sink { _ in self.tick() }
        }
    }
    
    func tick() {
        if currentValue <= Duration.zero {
            completeCountdown()
            return
        }
        
        if active {
            currentValue -= Duration.milliseconds(TimerUnitViewModel.PUBLISHING_INTERVAL_MS);
        }
    }
    
    func completeCountdown() {
        active = false;
        timerCancellable?.cancel()
        timer = nil
        onCompletion()
    }
    
    func reInit(currentValue: Duration, activate: Bool = true)  {
        self.currentValue = currentValue
        if activate { toggleActive() }
    }
}
