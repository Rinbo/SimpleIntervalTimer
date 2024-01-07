//
//  Timer.swift
//  SimpleIntervalTimer
//
//  Created by Robin Börjesson on 2024-01-07.
//

import Foundation

class AppTimer {

    private var timerCount : Duration
    private var active : Bool = false
    
    init(timerCount: Duration) {
        self.timerCount = timerCount
    }
    
    func start() {
        active = true
    }
    
    func stop() {
        active = false
    }
    
    
}
