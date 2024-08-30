import SwiftUI

/// The View that wraps the initial View of the Navigation.
public struct RootView<Content>: View where Content: View {
    @StateObject var navigator: Navigator
    private let content: () -> Content
    
    ///
    /// - Parameters:
    ///   - viewProvider: A Closure that resolves the specific View type corresponding to the destination identifier.
    ///   - content: The wrapped View.
    public init(
        @ViewBuilder viewProvider: @escaping (any NavigationDestination) -> some View,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.content = content
        self._navigator = StateObject(wrappedValue: Navigator(viewProvider))
    }

    /// The content and behavior of the view.
    public var body: some View {
        NavigationStack(path: $navigator.path) {
            content()
        }
        .environmentObject(navigator)
    }
}
