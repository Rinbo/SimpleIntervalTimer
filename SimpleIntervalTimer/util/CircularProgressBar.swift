import Foundation
import SwiftUI

struct CircularProgressBar<Content: View>: View {
    var progress: CGFloat
    @ViewBuilder var content: () -> Content
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: 18.0)
                .opacity(0.3)
                .foregroundColor(.gray)
            
            Circle()
                .trim(from: 0.0, to: CGFloat(min(self.progress, 1.0)))
                .stroke(style: StrokeStyle(lineWidth: 18.0, lineCap: .round, lineJoin: .round))
                .foregroundColor(Color.accentColor)
                .rotationEffect(Angle(degrees: 270.0))
                .animation(.linear, value: progress)
            
            content()
        }
    }
}
