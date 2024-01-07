import Foundation

class AppTimer {

    private var active : Bool
    private var timerCount : Duration
    private var timer : Timer?
       
    init(timerCount: Duration) {
        self.active = false;
        self.timerCount = timerCount
    }
    
    func start() {
        if active == false {
            timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in self.tick()}
            active = true
        }
    }
    
    func stop() {
        if active == true {
            timer?.invalidate()
            active = false
        }
    }
    
    func tick() {
        if (timerCount <= Duration.zero) {
            timerCount = Duration.seconds(60);
            active = false;
            timer?.invalidate()
            return;
        }
        
        if active == true {
            print("ticking...")
            timerCount -= timerCount - Duration.seconds(1)
        }
    }
    
    func getTimerCount() -> Duration {
        return timerCount;
    }
}
