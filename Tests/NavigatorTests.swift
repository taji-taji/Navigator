import SwiftUI
import XCTest
@testable import Navigator

final class NavigatorTests: XCTestCase {
    func testNavigateTo() {
        let navigator = Navigator { _ in }
        XCTAssertEqual(navigator.path.count, 0)
        navigator.navigate(to: Destination.test1)
        XCTAssertEqual(navigator.path.count, 1)
    }
    
    func testBackOnce() {
        let navigator = Navigator { _ in }
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        XCTAssertEqual(navigator.path.count, 2)
        navigator.back()
        XCTAssertEqual(navigator.path.count, 1)
    }
    
    func testBackToMultiplePage() {
        let navigator = Navigator { _ in }
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        XCTAssertEqual(navigator.path.count, 4)
        navigator.back(2)
        XCTAssertEqual(navigator.path.count, 2)
    }

    func testBackToRoot() {
        let navigator = Navigator { _ in }
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        navigator.navigate(to: Destination.test1)
        XCTAssertEqual(navigator.path.count, 4)
        navigator.backToRoot()
        XCTAssertEqual(navigator.path.count, 0)
    }
    
    func testViewForDestination() {
        func viewProvider(destination: any NavigationDestination) -> some View {
            switch destination {
            case let d as NavigatorTests.Destination:
                switch d {
                case .test1:
                    return EmptyView()
                case .test2:
                    XCTFail()
                    return EmptyView()
                }
            default:
                XCTFail()
                return EmptyView()
            }
        }
        let navigator = Navigator(viewProvider)
        _ = navigator.view(for: Destination.test1)
    }
}

 extension NavigatorTests {
    enum Destination: NavigationDestination {
        case test1
        case test2
    }
}
