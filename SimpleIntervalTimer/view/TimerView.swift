import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @StateObject var timerController: TimerController
    
    var body: some View {
        
        VStack {
            Spacer()
            if timerController.isRestRound { Text("RESTING") }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        
        
        VStack {
            Text(timerController.description).font(.title)
            TimerUnitView(model: timerController.currentTimeUnitViewModel, isResting: timerController.isRestRound)
        }
    }
}
