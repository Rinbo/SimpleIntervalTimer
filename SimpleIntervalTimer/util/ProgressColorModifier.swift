import Foundation
import SwiftUI

struct ProgressColorModifier: ViewModifier {
    var progress: Double

    func body(content: Content) -> some View {
        content
            .progressViewStyle(
                LinearProgressViewStyle(
                    tint: Color(uiColor: UIColor(hue: CGFloat(0.33 * (1 - progress)), saturation: 1, brightness: 1, alpha: 1))))
    }
}
