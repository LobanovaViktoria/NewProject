import SwiftUI

class AppLauncher: Observable {
    enum LaunchState {
        case splash
        case loading
    }
    
    var launchState = LaunchState.splash
    
    func splash() {
        launchState = .splash
    }
    
    func load() {
        launchState = .loading
    }
}
