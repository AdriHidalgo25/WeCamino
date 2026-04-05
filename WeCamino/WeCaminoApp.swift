import SwiftUI

@main
struct WeCaminoApp: App {
    var body: some Scene {
        WindowGroup {
            AppRootView(dependencies: .live)
        }
    }
}
