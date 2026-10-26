import SwiftUI

struct FastfetchView: View {
    var body: some View {
        ScrollView {
            Text(DeviceInfo.fastfetchText)
                .font(.system(.footnote, design: .monospaced))
                .frame(maxWidth: .infinity, alignment: .leading)
                .textSelection(.enabled)
                .padding()
        }
        .navigationTitle("Fastfetch")
    }
}
