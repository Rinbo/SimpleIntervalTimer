import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @StateObject var timerController: TimerController
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Text(timerController.description).font(.title)
                TimerUnitView(model: timerController.currentTimeUnitViewModel)
            }
            .padding(30)
            
            if timerController.isRestRound { Text("RESTING") }
        }
    }
    
}

#Preview {
    MainView()
}
