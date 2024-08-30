import SwiftUI

/// An entity that represents an identifier indicating the destination.
public protocol NavigationDestination: Hashable, Codable {}

public final class Navigator: ObservableObject {
    @Published var path = NavigationPath()
    public let viewProvider: (any NavigationDestination) -> AnyView

    public init(@ViewBuilder _ viewProvider: @escaping (any NavigationDestination) -> some View) {
        self.viewProvider = { destination in
            AnyView(viewProvider(destination))
        }
    }

    /// Returns the View corresponding to the destination identifier.
    /// - Parameter destination: A destination identifier that conforms to the NavigationDestination protocol.
    /// - Returns: the View corresponding to the destination identifier.
    public func view<Destination: NavigationDestination>(for destination: Destination) -> some View {
        viewProvider(destination)
    }
    
    /// Triggers a screen transition to the screen represented by the identifier.
    /// - Parameter destination: A destination identifier that conforms to the NavigationDestination protocol.
    public func navigate<Destination: NavigationDestination>(to destination: Destination) {
        path.append(destination)
    }
    
    /// Navigates back by the number of screens specified in the argument.
    /// - Parameter count: The number of screens to go back.
    public func back(_ count: Int = 1) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }
    
    /// Returns to the root of the navigation stack.
    public func backToRoot() {
        path = .init()
    }
}
