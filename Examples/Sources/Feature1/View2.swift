import SwiftUI
import Navigator

public struct View2: View {
    @EnvironmentObject private var navigator: Navigator
    public init() {}

    public var body: some View {
        VStack {
            Text("View2")
            Button("Back to Root") {
                navigator.backToRoot()
            }
        }
        .navigationTitle("View2")
    }
}
