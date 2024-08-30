# 🚗 Navigator (for SwiftUI x Multiple Modules)

`Navigator` is a `Router` library for SwiftUI.

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftaji-taji%2FNavigator%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/taji-taji/Navigator)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Ftaji-taji%2FNavigator%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/taji-taji/Navigator)  
![](https://img.shields.io/badge/iOS-16.0+-brightgreen)
![](https://img.shields.io/badge/macOS-13.0+-brightgreen)
![](https://img.shields.io/badge/tvOS-16.0+-brightgreen)
![](https://img.shields.io/badge/visionOS-1.0+-brightgreen)
![](https://img.shields.io/badge/watchOS-9.0+-brightgreen)

## Feature

It supports the implementation of routing that is independent between features in a modularized application by feature.

## Motivation

In an app composed of multiple Feature modules, we want to eliminate dependencies between Feature modules to facilitate development on a per-Feature basis.  
However, there are cases where the destination screen is from a different Feature module.  
In such situations, we want to manage screen transitions without needing to know the specific type of the destination screen.

## Usage

### Install

`Navigator` is distributed via Swift Package Manager.  
Please add the following to the dependencies in `Package.swift`.

```swift
.package(url: "https://github.com/taji-taji/Navigator", from: "0.0.1"),
```

### Steps

#### Step 1


First, wrap the initial screen of the screen transition in a RootView.

```swift
import SwiftUI
import AppFeature
// ⭐️ 1️⃣ - Import `Navigator` module
import Navigator

@main
struct NavigatorExampleApp: App {
    var body: some Scene {
        WindowGroup {
            // ⭐️ 2️⃣ - Wrap ContentView with `RootView`
            RootView(viewProvider: viewProvider) { // ⭐️ 3️⃣
                ContentView()
            }
        }
    }
}
```

⭐️ 3️⃣ The `viewProvider` argument is a closure with the signature `@ViewBuilder viewProvider: @escaping (any NavigationDestination) -> some View`. In this example, a method named `viewProvider` that follows this signature is defined as follows:

```swift
import SwiftUI
// ⭐️ 1️⃣ - Import `Navigator` module
import Navigator

// ⭐️ 2️⃣ - Define a method to use as an argument for `RootView`
@ViewBuilder
public func viewProvider(destination: any NavigationDestination) -> some View {
    // ⭐️ 3️⃣
    EmptyView()
}
```

This method (or closure) maps the abstracted destinations to their corresponding concrete `View` types, so it should be defined in a module that depends on each feature, such as the app target module.

⭐️ 3️⃣ At this stage, since the destination has not been defined in each Feature module, you can return EmptyView() as a placeholder. (Alternatively, you can use fatalError() as well.)

Of course, you can also write the closure directly as an argument to `RootView`.

#### Step 2

Use `Navigator` in each Feature module.  
In the following example, we will use `Navigator` with a screen named `View1` inside a module called `Feature1`.

```swift
import SwiftUI
// ⭐️ 1️⃣ - Import `Navigator` module
import Navigator

public struct View1: View, Navigatable /* ⭐️ 2️⃣ - Conform to the `Navigatable` protocol */  {
    // ⭐️ 3️⃣ - Implement a `Destination` type that conforms to the `NavigationDestination` protocol.
    // The `Destination` type abstractly represents the screens to which transitions occur from this screen.
    // In this example, `view3` is a screen located in the `Feature2` module, not in the `Feature1` module.
    // However, you do not need to know the specific type of `View` here.
    // In other words, there is no need to depend on `Feature2`.
    public enum Destination: NavigationDestination {
        case view2
        case view3(fromView: String)
    }
    // ⭐️ 4️⃣ - Implement a `navigator` property that conforms to the `Navigatable` protocol.
    @EnvironmentObject public var navigator: Navigator

    public init() {}

    public var body: some View {
        VStack {
            Text("View1")
            Button("to View2") {
                // ⭐️ 5️⃣ - By conforming to the `Navigatable` protocol, you can use the `navigate(to:)` protocol method.
                // Call the `navigate(to:)` method wherever you want to perform a screen transition.
                // Here, since we want to transition to `view2`, we pass `Destination.view2` as the argument.
                navigate(to: Destination.view2)
            }
            Button("to View3") {
                // ✅ Since `navigate(to:)` is a wrapper around `navigator.navigate(to:)`, you can also directly use `navigator.navigate(to:)`.
                navigator.navigate(to: Destination.view3(fromView: "View1")) 
            }
        }
        .navigationTitle("View1")
        // ⭐️ 6️⃣ - Use the `navigatable(for:)` modifier on the `View` in the body.
        // ⚠️ Without this, screen transitions will not be possible, so make sure not to forget it.
        .navigatable(for: Destination.self)
    }
}
```

Or use `@Navigatable` macro.
By applying the `@Navigatable` macro, the following can be omitted:

- You no longer need to explicitly declare conformance to the `Navigatable` protocol
- You no longer need to explicitly declare the `navigator` property

```swift
import SwiftUI
import Navigator

// ⭐️ 1️⃣ - Attach `@Navigatable` macro to View
@Navigatable
public struct View1: View /* ⭐️ 2️⃣ - No need to write `Navigatable` protocol */  {
    public enum Destination: NavigationDestination {
        case view2
        case view3(fromView: String)
    }
    // ⭐️ 3️⃣ - No need to write `navigator` property

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
```

> [!WARNING]
> A `View` conforming to the `Navigatable` protocol must have a `RootView` at the top level of the view hierarchy.
> This is because it internally uses an `EnvironmentObject` injected by `RootView`.

For the above reason, when using Preview, you need to wrap it in a `RootView`.
Here is an example of a preview for `View1`:

```swift
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
```

#### Step 3

Complete the `viewProperty` method defined in Step 1.

```swift
import SwiftUI
import Navigator
import Feature1
import Feature2

@ViewBuilder
public func viewProvider(destination: any NavigationDestination) -> some View {
    switch destination {
    // ⭐️ 1️⃣ - Return the `View` corresponding to the `View1.Destination` enum.
    case let d as View1.Destination:
        switch d {
        case .view2:
            View2()
        case let .view3(fromView):
            // ⭐️ 2️⃣ - `View3` is a type from the `Feature2` module.
            View3(fromView: fromView)
        }
    default:
        fatalError()
    }
}
```

### Other usage

#### with `NavigationLink`

```swift
import SwiftUI
import Navigator

@Navigatable
public struct ContentView: View {
    public enum Destination: NavigationDestination {
        case view1
        case view3(fromView: String)
    }

    public init() {}

    public var body: some View {
        List {
            // ⭐️ 1️⃣ - Using `Navigator` with `NavigationLink` is straightforward:
            // simply pass a `Destination` value to the `value` parameter,
            // and screen transitions will occur when the `NavigationLink` is tapped.
            NavigationLink("to View1", value: Destination.view1)
            NavigationLink("to View3", value: Destination.view3(fromView: "ContentView"))
        }
        .navigationTitle("ContentView")
        .navigatable(for: Destination.self)
    }
}
```

#### Go Back

```swift
import SwiftUI
import Navigator

@Navigatable
public struct MyView: View  {
    public struct Destination: NavigationDestination {}

    public init() {}

    public var body: some View {
        VStack {
            Button("Go back previous page") {
                // ⭐️ 1️⃣ - Go back previous page
                navigateBack()
            }
            Button("Go back two pages") {
                // ⭐️ 2️⃣ - Specify the number of pages to go back
                navigateBack(2)
            }
            Button("Go back to root page") {
                // ⭐️ 3️⃣ - Go back to root page
                navigateBackToRoot()
            }
        }
        .navigationTitle("MyView")
        .navigatable(for: Destination.self)
    }
}
```

#### Present Sheet

```swift
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
        }
        .sheet(isPresented: $isPresented) {
            // ⭐️ 1️⃣ - When displaying a sheet, the displayed screen becomes the root of the navigation.
            // Therefore, use the `rootView(with:)` method to transition to a screen wrapped in `RootView`.
            rootView(with: Destination.view4)
        }
        .navigationTitle("View3")
    }
}
```
