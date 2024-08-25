import SwiftUI
import Navigator
import Feature1
import Feature2
import Feature3

@ViewBuilder
public func viewProvider(destination: any NavigationDestination) -> some View {
    switch destination {
    case let d as ContentView.Destination:
        switch d {
        case .view1:
            View1()
        case let .view3(fromView):
            View3(fromView: fromView)
        }
    case let d as View1.Destination:
        switch d {
        case .view2:
            View2()
        case let .view3(fromView):
            View3(fromView: fromView)
        }
    case let d as View3.Destination:
        switch d {
        case .view4:
            View4()
        }
    default:
        fatalError()
    }
}
