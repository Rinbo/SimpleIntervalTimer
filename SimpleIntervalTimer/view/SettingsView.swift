import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State var selectedRestDuration: Duration
    @State var selectedRoundDuration: Duration
    @State var selectedNumberOfRounds: Int
    
    private var restDurations: [DurationOption] {
        AppConfig.restDurations.map { DurationOption(duration: $0) }
    }
    
    private var roundDurations: [DurationOption] {
        AppConfig.roundDurations.map { DurationOption(duration: $0) }
    }
    
    init(isPresented: Binding<Bool>, settingsModel: SettingsModel) {
        self._isPresented = isPresented
        self._selectedRestDuration = State(initialValue: settingsModel.restDuration)
        self.selectedRoundDuration = settingsModel.roundDuration
        self.selectedNumberOfRounds = settingsModel.numberOfRounds
    }
    
    var body: some View {
        HStack {
            VStack {
                Text("Rest").font(.title)
                Picker("Rest", selection: $selectedRestDuration) {
                    ForEach(restDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
            }
            
            VStack {
                Text("Round").font(.title)
                Picker("Rest", selection: $selectedRoundDuration) {
                    ForEach(roundDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
            }
            
            
        }
        Button(action: { isPresented = false}){
            Image(systemName: "checkmark")
                .font(.system(size: 60))
        }
        .foregroundColor(.green)
        .font(.largeTitle)
        .padding(20)
    }
}

struct DurationOption: Identifiable {
    let duration: Duration
    var label: String { duration.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))) }
    var id: String { label }
}

struct AppConfig {
    static let restDurations: [Duration] = [
        Duration.zero,
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(60)
    ]
    
    static let roundDurations: [Duration] = [
        Duration.zero,
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(60)
    ]
}


#Preview {
    MainView(timerController: TimerController(settingsModel: SettingsModel()))
}
