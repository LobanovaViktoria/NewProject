import SwiftUI

@main
struct NewProjectApp: App {
    
    @AppStorage("shouldShowSplash") var shouldShowSplash: Bool = true
    @ObservedObject var coordinator = BaseCoordinator()
    @StateObject var listViewModel = ListViewModel()
    @State private var launcher = AppLauncher()
    @State var detentHeight: CGFloat = 0
    
    var body: some Scene {
        WindowGroup {
            bodyContentView(
                launchState: shouldShowSplash
                ? AppLauncher.LaunchState.splash
                : AppLauncher.LaunchState.loading
            )
            .onAppear {
                shouldShowSplash
                ? launcher.splash()
                : launcher.load()
            }
        }
    }
    
    @ViewBuilder
    private func bodyContentView(
        launchState: AppLauncher.LaunchState
    ) -> some View {
        
        switch launchState {
            
        case .splash:
            SplashScreen(shouldShowSplash: $shouldShowSplash)
            
        case .loading:
            NavigationStack(path: $coordinator.path) {
                ZStack {
                    appContent()
                        .sheet(item: $coordinator.presentSheetItem) { present in
                            ViewFactory.viewForDestination(present)
                                .readHeight()
                                .presentationDragIndicator(.hidden)
                                
                                .onPreferenceChange(HeightPreferenceKey.self) { height in
                                    if let height {
                                        self.detentHeight = height
                                    }
                                }
                                .presentationDetents([.height(self.detentHeight)])
                        }
                        .fullScreenCover(item: $coordinator.fullCoverItem) { present in
                            ViewFactory.viewForDestination(present)
                        }
                }
                .navigationDestination(for: DestinationFlowPage.self) { destination in
                    ViewFactory.viewForDestination(destination)
                }
            }
            .environmentObject(coordinator)
            .environmentObject(listViewModel)
        }
    }
    
    @ViewBuilder func appContent() -> some View {
        ViewFactory.getList()
    }
}
