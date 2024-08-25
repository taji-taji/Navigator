import SwiftUI
import Navigator

@Navigatable
public struct View3: View {
    public enum Destination: NavigationDestination {
        case view4
    }

    @State private var isPresented = false
    private let fromView: String

    public init(fromView: String) {
        self.fromView = fromView
    }

    public var body: some View {
        VStack {
            Text("View3 (from: \(fromView))")
            Button("to View4") {
                isPresented = true
            }
            Button("Back") {
                navigateBack()
            }
        }
        .sheet(isPresented: $isPresented) {
            rootView(with: Destination.view4)
        }
        .navigationTitle("View3")
    }
}
