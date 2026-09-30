import ActivityKit
import Foundation

// Shared between the app and the widget extension: describes what the lock screen / Dynamic Island shows.
struct IntervalTimerAttributes: ActivityAttributes {
    struct ContentState: Codable, Hashable {
        var isRest: Bool
        var currentRound: Int
        var totalRounds: Int
        // Full length of the current round or rest, used for the progress bar.
        var phaseDuration: TimeInterval
        // When the current round or rest ends. The system counts down to it on its own,
        // so the app doesn't need to push an update every second.
        var endDate: Date
        // Set while paused: the countdown is frozen at this many seconds.
        var pausedRemaining: TimeInterval?

        var isPaused: Bool { pausedRemaining != nil }
        var startDate: Date { endDate.addingTimeInterval(-phaseDuration) }
    }
}
