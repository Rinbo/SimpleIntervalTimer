import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @ObservedObject var controller: TimerController
    @ObservedObject var model: TimerViewModel
    
    var body: some View {
        VStack {
            
            ProgressView(value: calculateProgress()){
                HStack{
                    Spacer()
                    Text(model.currentValue.formatted(Duration.TimeFormatStyle.time(pattern: .minuteSecond(padMinuteToLength: 2))))
                        .font(.system(size: 100))
                        .foregroundColor(controller.isRestRound ? .gray : .primary)
                    Spacer()
                }
                
            }
            .modifier(ProgressColorModifier(progress: calculateProgress()))
            .padding(.all, 50)
        }
        
        Button(action: { model.toggleActive() }) {
            Image(systemName: model.active ? "pause.circle.fill": "play.circle.fill")
                .frame(width: 100, height: 100)
                .font(.system(size: 100))
                .background(Color(UIColor.systemBackground))
                .scaledToFit()
            
        }
        .buttonStyle(.borderless)
        .foregroundColor(.green)
        .clipShape(Circle())
        .transaction { transaction in
            transaction.disablesAnimations = true
        }
    }
    
    private func calculateProgress() -> Double {
        let settingsModel = controller.settingsModel
        let roundDuration = controller.isRestRound ? settingsModel.restDuration : settingsModel.roundDuration
        return (roundDuration - model.currentValue) / roundDuration
    }
}

#Preview {
    MainView(controller: TimerController(settingsModel: SettingsModel()))
}
