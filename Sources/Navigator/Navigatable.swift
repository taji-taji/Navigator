import SwiftUI

public protocol Navigatable where Self: View {
    associatedtype Destination: NavigationDestination
    var navigator: Navigator { get }
}

public extension Navigatable {
    func navigateBack(_ count: Int = 1) {
        navigator.back(count)
    }
    
    func navigateBackToRoot() {
        navigator.backToRoot()
    }
    
    func navigate(to destination: Destination) {
        navigator.navigate(to: destination)
    }
    
    func rootView(with destination: Destination) -> RootView<AnyView> {
        RootView(viewProvider: navigator.viewProvider) {
            AnyView(navigator.view(for: destination))
        }
    }
}

public extension View {
    func navigatable<D>(for destinationType: D.Type) -> some View where D: NavigationDestination {
        modifier(_Navigatable<D>())
    }
}

private struct _Navigatable<Destination>: ViewModifier where Destination: NavigationDestination {
    @EnvironmentObject private var navigator: Navigator
    init() {}
    
    func body(content: Content) -> some View {
        content
            .navigationDestination(for: Destination.self) { destination in
                navigator.view(for: destination)
            }
    }
}

@attached(extension, conformances: Navigatable)
@attached(member, names: named(navigator))
public macro Navigatable() = #externalMacro(module: "NavigatableMacros", type: "NavigatableMacro")
