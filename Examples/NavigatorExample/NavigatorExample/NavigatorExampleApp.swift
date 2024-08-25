import SwiftUI
import AppFeature
import Navigator

@main
struct NavigatorExampleApp: App {
    var body: some Scene {
        WindowGroup {
            RootView(viewProvider: viewProvider) {
                ContentView()
            }
        }
    }
}
