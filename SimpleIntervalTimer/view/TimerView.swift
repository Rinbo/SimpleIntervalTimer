import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @StateObject var timerController: TimerController
    
    var body: some View {
        
        VStack {
            // Consider having a "toast" functionality instead
            // To display any message
            Spacer()
            if timerController.isRestRound { Text("RESTING") }
        }
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, maxHeight: .infinity)
        
        
        VStack {
            Text(timerController.description).font(.title)
            TimerUnitView(model: timerController.currentTimeUnitViewModel)
        }
    }
}
