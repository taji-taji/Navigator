import SwiftUI

public protocol NavigationDestination: Hashable, Codable {}

public final class Navigator: ObservableObject {
    @Published var path = NavigationPath()
    public let viewProvider: (any NavigationDestination) -> AnyView

    public init(@ViewBuilder _ viewProvider: @escaping (any NavigationDestination) -> some View) {
        self.viewProvider = { destination in
            AnyView(viewProvider(destination))
        }
    }

    public func view<Destination: NavigationDestination>(for destination: Destination) -> some View {
        viewProvider(destination)
    }

    public func navigate<Destination: NavigationDestination>(to destination: Destination) {
        path.append(destination)
    }

    public func back(_ count: Int = 1) {
        guard path.count >= count else { return }
        path.removeLast(count)
    }

    public func backToRoot() {
        path = .init()
    }
}
