import SwiftUI

public struct View4: View {
    @Environment(\.dismiss) private var dismiss

    public init() {}
    
    public var body: some View {
        Text("View4")
            .navigationTitle("View4")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Close")
                    }
                }
            }
    }
}
