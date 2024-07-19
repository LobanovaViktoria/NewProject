import SwiftUI

struct SplashScreen: View {
    
    // MARK: - Properties
    
    @Binding var shouldShowSplash: Bool

    // MARK: - Body
    
    var body: some View {
        ZStack {
            Color.blackUniversal
            Image("splash")
                .resizable()
                .ignoresSafeArea()
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(
                deadline: .now() + 2) {
                    withAnimation {
                        self.shouldShowSplash = false
                    }
                }
        }
    }
}

// MARK: - Preview

#Preview {
    SplashScreen(shouldShowSplash: .constant(true))
}
