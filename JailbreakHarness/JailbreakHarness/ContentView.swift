import SwiftUI

/// Jailbreak-attempt harness UI. This app is a research scaffold:
/// it is NOT a working jailbreak and says so on screen.
struct ContentView: View {
    @State private var harness = JailbreakHarness()

    var body: some View {
        TabView {
            NavigationStack {
                VStack(spacing: 16) {
                    VStack(spacing: 6) {
                        Image(systemName: "lock.open.display")
                            .font(.largeTitle)
                        Text("iOS 18.7.1 Jailbreak Harness")
                            .font(.headline)
                        Text("\(DeviceInfo.marketingName) · iOS \(DeviceInfo.iosVersion)")
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                        Text("Research scaffold — not a working jailbreak. The exploit stage ships no code, and the terminal state is always \u{201C}Not jailbroken\u{201D}.")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                    }

                    Button {
                        Task { await harness.run() }
                    } label: {
                        Text(harness.isRunning ? "Running…" : "Run Jailbreak Attempt")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(harness.isRunning)

                    if !harness.log.isEmpty {
                        ScrollView {
                            Text(harness.logText)
                                .font(.system(.caption, design: .monospaced))
                                .frame(maxWidth: .infinity, alignment: .leading)
                                .textSelection(.enabled)
                        }
                        .frame(maxHeight: .infinity)
                    }

                    if harness.finished {
                        ShareLink(item: harness.logText) {
                            Label("Export Log", systemImage: "square.and.arrow.up")
                        }
                    }
                }
                .padding()
                .navigationTitle("Harness")
            }
            .tabItem { Label("Jailbreak", systemImage: "hammer") }

            NavigationStack {
                FastfetchView()
            }
            .tabItem { Label("Fastfetch", systemImage: "speedometer") }

            NavigationStack {
                List {
                    Section("Status for iPhone 14 (A15) · iOS 18.7.1") {
                        Text("Kernel bug (CVE-2025-43520, ClearSword): in range — patched in 18.7.2.")
                        Text("PPL/SPTM bypass for A15 on iOS 18: not public. This is the blocker.")
                        Text("Dopamine 3: A15 support ends at iOS 17.3.1; 18.7.1 support is A12/A13 only.")
                        Text("Lara: customization toolbox on the same kernel exploit for 17.0–18.7.1 — not a full jailbreak/bootstrap.")
                    }
                    Section("Safety") {
                        Text("Proof of concept for your own device only. Nothing in this app writes to the system.")
                    }
                }
                .navigationTitle("About")
            }
            .tabItem { Label("About", systemImage: "info.circle") }
        }
    }
}

#Preview {
    ContentView()
}
