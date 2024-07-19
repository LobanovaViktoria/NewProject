import SwiftUI

extension AsyncImage {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
            .scaledToFill()
            .frame(width: geo.size.width, height: geo.size.height)
            .clipped()
        }
    }
}
