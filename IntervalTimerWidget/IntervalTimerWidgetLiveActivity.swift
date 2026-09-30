import ActivityKit
import WidgetKit
import SwiftUI

typealias TimerState = IntervalTimerAttributes.ContentState

struct IntervalTimerWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: IntervalTimerAttributes.self) { context in
            LockScreenView(state: context.state)
                .padding(.horizontal, 20)
                .padding(.vertical, 16)
        } dynamicIsland: { context in
            let state = context.state
            return DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    PhaseLabel(state: state)
                        .padding(.leading, 6)
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Countdown(state: state)
                        .font(.system(size: 40, weight: .semibold))
                        .padding(.trailing, 6)
                }
                DynamicIslandExpandedRegion(.bottom) {
                    PhaseProgress(state: state)
                        .padding(.horizontal, 6)
                }
            } compactLeading: {
                Text("\(state.currentRound)/\(state.totalRounds)")
                    .fontWeight(.semibold)
                    .foregroundStyle(state.phaseColor)
            } compactTrailing: {
                Countdown(state: state)
                    .frame(maxWidth: 48)
            } minimal: {
                Image(systemName: state.isPaused ? "pause.fill" : "timer")
                    .foregroundStyle(state.phaseColor)
            }
            .keylineTint(state.phaseColor)
        }
    }
}

private struct LockScreenView: View {
    let state: TimerState

    var body: some View {
        VStack(spacing: 12) {
            HStack(alignment: .center) {
                PhaseLabel(state: state)
                Countdown(state: state)
                    .font(.system(size: 48, weight: .semibold))
            }
            PhaseProgress(state: state)
        }
    }
}

private struct PhaseLabel: View {
    let state: TimerState

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 4) {
                if state.isPaused {
                    Image(systemName: "pause.fill")
                }
                Text(state.isPaused ? "Paused" : state.isRest ? "Rest" : "Round")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)

            Text("\(state.currentRound) / \(state.totalRounds)")
                .font(.title2.bold())
                .monospacedDigit()
        }
        .fixedSize()
    }
}

private struct Countdown: View {
    let state: TimerState

    var body: some View {
        Group {
            if let remaining = state.pausedRemaining {
                Text(Duration.seconds(remaining.rounded(.up)).formatted(.time(pattern: .minuteSecond)))
            } else {
                // Counts down by itself on the lock screen; no updates from the app needed.
                Text(timerInterval: state.startDate...state.endDate, countsDown: true)
            }
        }
        .monospacedDigit()
        .multilineTextAlignment(.trailing)
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundStyle(state.isRest ? .secondary : .primary)
    }
}

private struct PhaseProgress: View {
    let state: TimerState

    var body: some View {
        Group {
            if let remaining = state.pausedRemaining {
                ProgressView(value: max(0, min(1, 1 - remaining / state.phaseDuration)))
            } else {
                ProgressView(timerInterval: state.startDate...state.endDate, countsDown: false) {
                    EmptyView()
                } currentValueLabel: {
                    EmptyView()
                }
            }
        }
        .tint(state.phaseColor)
    }
}

private extension TimerState {
    var phaseColor: Color { isRest ? .gray : .green }
}

#Preview("Lock screen", as: .content, using: IntervalTimerAttributes()) {
    IntervalTimerWidgetLiveActivity()
} contentStates: {
    TimerState(isRest: false, currentRound: 2, totalRounds: 3, phaseDuration: 180, endDate: .now.addingTimeInterval(95), pausedRemaining: nil)
    TimerState(isRest: true, currentRound: 2, totalRounds: 3, phaseDuration: 60, endDate: .now.addingTimeInterval(40), pausedRemaining: nil)
    TimerState(isRest: false, currentRound: 1, totalRounds: 3, phaseDuration: 180, endDate: .now, pausedRemaining: 72)
}
