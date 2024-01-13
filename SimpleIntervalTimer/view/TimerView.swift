import Foundation
import SwiftUI
import Combine

struct TimerView : View {
    @StateObject var timerController: TimerController
    
    var body: some View {
        TimerUnitView(model: timerController.currentTimeUnitViewModel)
    }
}
