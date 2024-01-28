import Foundation
import SwiftUI

struct SettingsView: View {
    @Binding var isPresented: Bool
    @State var selectedRestDuration: Duration
    @State var selectedRoundDuration: Duration
    @State var selectedNumberOfRounds: Int
    @State var selectedWarningDuration: Duration
    
    private let callback: (_ settingsModel: SettingsModel) -> Void
    
    private var restDurations: [DurationOption] {
        AppConfig.restDurations.map { DurationOption(duration: $0) }
    }
    
    private var roundDurations: [DurationOption] {
        AppConfig.roundDurations.map { DurationOption(duration: $0) }
    }
    
    private var warningDurations: [WarningOption] {
        AppConfig.warningDurations.map { WarningOption(duration: $0) }
    }
    
    init(isPresented: Binding<Bool>, settingsModel: SettingsModel, callback: @escaping (_ settingsModel: SettingsModel) -> Void) {
        self._isPresented = isPresented
        self.selectedRestDuration = settingsModel.restDuration
        self.selectedRoundDuration = settingsModel.roundDuration
        self.selectedNumberOfRounds = settingsModel.numberOfRounds
        self.selectedWarningDuration = settingsModel.warningDuration
        self.callback = callback
    }
    
    var body: some View {
        Spacer()
        HStack {
            VStack {
                Text("Round Duration")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier("RoundDurationTitle")
                
                Picker("Round Duration", selection: $selectedRoundDuration) {
                    ForEach(roundDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
                .accessibilityIdentifier("RoundDurationPicker")
            }
            
            VStack {
                Text("Rounds")
                    .font(.title3)
                    .accessibilityIdentifier("NumberOfRoundsTitle")
                
                Picker("Rounds", selection: $selectedNumberOfRounds) {
                    ForEach(1...20, id: \.self) { number in
                        Text("\(number)").tag(number)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
                .accessibilityIdentifier("NumberOfRoundsPicker")
            }
            
            VStack {
                Text("Rest Duration")
                    .font(.title3)
                    .multilineTextAlignment(.center)
                    .accessibilityIdentifier("RestDurationTitle")
                
                Picker("Rest Duration", selection: $selectedRestDuration) {
                    ForEach(restDurations) { option in
                        Text(option.label).tag(option.duration)
                    }
                }
                .pickerStyle(WheelPickerStyle())
                .clipped()
                .accessibilityIdentifier("RestDurationPicker")
            }
        }.padding(20)
        
        Text("End of round alert")
            .font(.title3)
            .padding(.top, 30)
            .accessibilityIdentifier("EndOfRoundAlertTitle")
        
        Picker("End of round alert", selection: $selectedWarningDuration) {
            ForEach(warningDurations) { option in
                Text(option.label).tag(option.duration)
            }
        }
        .font(/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/)
        .pickerStyle(PalettePickerStyle())
        .clipped()
        .accessibilityIdentifier("EndOfRoundAlertPicker")
        
        Spacer()
        Button(action: {
            isPresented = false
            callback(SettingsModel(
                numberOfRounds: selectedNumberOfRounds,
                roundDuration: selectedRoundDuration,
                restDuration: selectedRestDuration,
                warningDuration: selectedWarningDuration))
        }){
            Image(systemName: "checkmark")
                .font(.system(size: 50))
        }
        .foregroundColor(.green)
        .font(.largeTitle)
        .padding(20)
        .accessibilityIdentifier("SaveSettingsButton")
    }
}

struct DurationOption: Identifiable {
    let duration: Duration
    var label: String { duration.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))) }
    var id: String { label }
}

struct WarningOption: Identifiable {
    let duration: Duration
    var label: String {
        if duration > Duration.zero { return "\(duration.components.seconds)s"}
        return "Off"
    }
    var id: String { label }
}

struct AppConfig {
    static let restDurations: [Duration] = [
        Duration.zero,
        Duration.seconds(5),
        Duration.seconds(10),
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(60),
        Duration.seconds(90),
        Duration.seconds(120),
        Duration.seconds(180),
        Duration.seconds(300)
    ]
    
    static let roundDurations: [Duration] = [
        Duration.seconds(5),
        Duration.seconds(10),
        Duration.seconds(15),
        Duration.seconds(30),
        Duration.seconds(45),
        Duration.seconds(60),
        Duration.seconds(90),
        Duration.seconds(120),
        Duration.seconds(180),
        Duration.seconds(240),
        Duration.seconds(300),
        Duration.seconds(360),
        Duration.seconds(420),
        Duration.seconds(480),
        Duration.seconds(540),
        Duration.seconds(600),
        Duration.seconds(900),
        Duration.seconds(1200),
        Duration.seconds(1800),
        Duration.seconds(3600)
    ]
    
    static let warningDurations: [Duration] = [
        Duration.seconds(0),
        Duration.seconds(10),
        Duration.seconds(30),
    ]
}


#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
