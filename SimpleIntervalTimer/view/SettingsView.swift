import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State var selectedRestDuration: Duration
    @State var selectedRoundDuration: Duration
    @State var selectedNumberOfRounds: Int
    private let callback: (_ settingsModel: SettingsModel) -> Void
    
    private var restDurations: [DurationOption] {
        AppConfig.restDurations.map { DurationOption(duration: $0) }
    }
    
    private var roundDurations: [DurationOption] {
        AppConfig.roundDurations.map { DurationOption(duration: $0) }
    }
    
    init(isPresented: Binding<Bool>, settingsModel: SettingsModel, callback: @escaping (_ settingsModel: SettingsModel) -> Void) {
        self._isPresented = isPresented
        self.selectedRestDuration = settingsModel.restDuration
        self.selectedRoundDuration = settingsModel.roundDuration
        self.selectedNumberOfRounds = settingsModel.numberOfRounds
        self.callback = callback
    }
    
    var body: some View {
        Spacer()
        HStack {
            VStack {
                Text("Round Duration").font(.title3).multilineTextAlignment(.center)
                Picker("Rest", selection: $selectedRoundDuration) {
                    ForEach(roundDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
            }
            
            VStack {
                Text("Rounds").font(.title3)
                Picker("Rest", selection: $selectedNumberOfRounds) {
                    ForEach(1...15, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
            }
            
            VStack {
                Text("Rest Duration").font(.title3).multilineTextAlignment(.center)
                Picker("Rest", selection: $selectedRestDuration) {
                    ForEach(restDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
            }
        }.padding(20)
        Spacer()
        Button(action: {
            isPresented = false
            callback(SettingsModel(numberOfRounds: selectedNumberOfRounds, roundDuration: selectedRoundDuration, restDuration: selectedRestDuration))
        }){
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
        Duration.seconds(5),
        Duration.seconds(10),
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(60)
    ]
    
    static let roundDurations: [Duration] = [
        Duration.seconds(5),
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(60),
        Duration.seconds(90)
    ]
}


#Preview {
    MainView(timerController: TimerController(settingsModel: SettingsModel()))
}
