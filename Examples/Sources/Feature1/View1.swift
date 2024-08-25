import SwiftUI
import Navigator

@Navigatable
public struct View1: View {
    public enum Destination: NavigationDestination {
        case view2
        case view3(fromView: String)
    }

    public init() {}

    public var body: some View {
        VStack {
            Text("View1")
            Button("to View2") {
                navigate(to: Destination.view2)
            }
            Button("to View3") {
                navigate(to: Destination.view3(fromView: "View1"))
            }
        }
        .navigationTitle("View1")
        .navigatable(for: Destination.self)
    }
}

#Preview {
    RootView(
        viewProvider: { _ in
            Text("Preview")
        },
        content: {
            View1()
        }
    )
}
