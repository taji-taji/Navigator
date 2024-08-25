import SwiftUI

public struct RootView<Content>: View where Content: View {
    @StateObject var navigator: Navigator
    private let content: () -> Content

    public init(
        @ViewBuilder viewProvider: @escaping (any NavigationDestination) -> some View,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self._navigator = StateObject(wrappedValue: Navigator(viewProvider))
    }

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            content()
        }
        .environmentObject(navigator)
    }
}
