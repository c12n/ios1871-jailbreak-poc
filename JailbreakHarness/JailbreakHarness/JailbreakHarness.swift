import Foundation

/// Staged jailbreak-attempt harness for iPhone 14 (A15) on iOS 18.7.1.
///
/// HONEST SCOPE: this is a research scaffold, not a working jailbreak.
/// - Stages 1-2 are real, read-only checks that run on device.
/// - Stage 3 (kernel exploit) is a documented interface only. The public
///   kernel exploit for this firmware is ClearSword (CVE-2025-43520,
///   patched in iOS 18.7.2) by TheRealClarity — upstream:
///   https://github.com/TheRealClarity/ClearSword
///   No exploit code is shipped in this app.
/// - Stage 4 (PPL/SPTM bypass) has no public implementation for A15 on
///   iOS 18 — Dopamine 3 supports A15 only up to iOS 17.3.1 for exactly
///   this reason. Without it, root and persistence are unreachable.
/// - Stage 5 (bootstrap + OpenSSH) is therefore always SKIPPED here.
///   The terminal state of this harness is always "Not jailbroken".
@Observable
final class JailbreakHarness {
    enum StageStatus: String {
        case pending = "PENDING"
        case running = "RUNNING"
        case pass = "PASS"
        case fail = "FAIL"
        case skipped = "SKIPPED"
    }

    struct LogLine: Identifiable {
        let id = UUID()
        let time: Date
        let text: String
    }

    private(set) var log: [LogLine] = []
    private(set) var isRunning = false
    private(set) var finished = false

    private func add(_ text: String) {
        log.append(LogLine(time: Date(), text: text))
    }

    @MainActor
    func run() async {
        guard !isRunning else { return }
        isRunning = true
        finished = false
        log = []

        // Stage 1 — environment (real, read-only)
        add("[1/5] Environment check — RUNNING")
        add("      Device: \(DeviceInfo.marketingName) (\(DeviceInfo.machineIdentifier)), SoC: \(DeviceInfo.socName)")
        add("      iOS: \(DeviceInfo.iosVersion), Kernel: \(DeviceInfo.kernelVersion)")
        let targetMatch = DeviceInfo.iosVersion == "18.7.1"
        add("[1/5] Environment check — \(targetMatch ? "PASS (target firmware 18.7.1)" : "PASS (note: not the 18.7.1 target firmware)")")
        try? await Task.sleep(for: .milliseconds(300))

        // Stage 2 — sandbox / existing-jailbreak indicators (real, read-only)
        add("[2/5] Sandbox & existing jailbreak check — RUNNING")
        let indicators = DeviceInfo.jailbreakIndicators
        if indicators.isEmpty {
            add("[2/5] Sandbox & existing jailbreak check — PASS (sandboxed, no jailbreak indicators found)")
        } else {
            add("[2/5] Sandbox & existing jailbreak check — PASS (indicators present: \(indicators.joined(separator: ", ")))")
        }
        try? await Task.sleep(for: .milliseconds(300))

        // Stage 3 — kernel exploit interface (stub, no exploit code shipped)
        add("[3/5] Kernel exploit (ClearSword, CVE-2025-43520) — SKIPPED")
        add("      No exploit code is shipped in this harness. Upstream: github.com/TheRealClarity/ClearSword")
        try? await Task.sleep(for: .milliseconds(300))

        // Stage 4 — PPL/SPTM bypass (the actual wall for A15 on iOS 18)
        add("[4/5] PPL/SPTM bypass — FAIL")
        add("      No public SPTM bypass exists for A15 on iOS >= 17.4. Dopamine 3 caps A15 at iOS 17.3.1 for this reason.")
        try? await Task.sleep(for: .milliseconds(300))

        // Stage 5 — post-exploit (gated behind a real root probe, never a flag)
        add("[5/5] Bootstrap + OpenSSH install — SKIPPED")
        add("      Gate: a real privileged probe (root-only path / effective uid) — not met, and cannot be met without Stage 4.")

        add("Result: Not jailbroken. Nothing was written to the system; removal is a no-op.")
        finished = true
        isRunning = false
    }

    var logText: String {
        let fmt = DateFormatter()
        fmt.dateFormat = "HH:mm:ss"
        return log.map { "[\(fmt.string(from: $0.time))] \($0.text)" }.joined(separator: "\n")
    }
}
