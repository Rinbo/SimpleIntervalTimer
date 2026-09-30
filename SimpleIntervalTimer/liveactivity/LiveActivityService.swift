import ActivityKit
import Foundation

// Shows the running timer on the lock screen and in the Dynamic Island.
class LiveActivityService {
    private var activity: Activity<IntervalTimerAttributes>?

    init() {
        // Clean up anything left behind if the app was killed while a timer was running.
        for staleActivity in Activity<IntervalTimerAttributes>.activities {
            Task { await staleActivity.end(nil, dismissalPolicy: .immediate) }
        }
    }

    func update(_ state: IntervalTimerAttributes.ContentState) {
        guard ActivityAuthorizationInfo().areActivitiesEnabled else { return }
        let content = ActivityContent(state: state, staleDate: nil)

        if let activity {
            Task { await activity.update(content) }
        } else {
            activity = try? Activity.request(attributes: IntervalTimerAttributes(), content: content)
        }
    }

    func end() {
        guard let activity else { return }
        self.activity = nil
        Task { await activity.end(nil, dismissalPolicy: .immediate) }
    }
}
