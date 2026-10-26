# iOS 18.7.1 Jailbreak PoC — Research & Scaffold

**Target:** iPhone 14 (Apple A15) on iOS 18.7.1
**Status:** Research scaffold. **This is not a working jailbreak**, and
nothing in this repository will jailbreak a device. Read the status below
before believing anyone who says otherwise about this device/firmware.

## TL;DR compatibility verdict (checked 2026-10-26, primary sources)

| Component | State for A15 + iOS 18.7.1 |
|---|---|
| Kernel vulnerability | **In range.** CVE-2025-43520 (the "DarkSword" kernel bug) affects iOS up to 18.7.1; Apple patched it in 18.7.2. |
| Kernel exploit | **Public.** [ClearSword](https://github.com/TheRealClarity/ClearSword) by TheRealClarity is a clean C reimplementation of the kernel stage, also integrated into Dopamine 3 and opa334's `darksword-kexploit`. |
| PPL/SPTM bypass | **Missing.** No public bypass exists for A15-class (SPTM) devices on iOS ≥ 17.4. This is the blocker for a full jailbreak. |
| Dopamine 3 | **Does not support this combo.** Its own README/changelog: A15 (arm64e) support ends at iOS 17.3.1; iOS 18.7.1 support is A12/A13 (via the *momentarius* PPL bypass) and arm64 only. |
| Bootstrap + OpenSSH | **Blocked by the missing bypass.** A Procursus-style bootstrap and an `sshd` daemon require the post-exploit primitives the bypass provides. Staged design lives in `payload/` and `docs/ARCHITECTURE.md`, gated and unimplemented. |
| Closest shipping tool | [Lara](https://github.com/rooootdev/lara) — a customization toolbox (file manager, tweaks) built on the same kernel exploit for iOS 17.0–18.7.1. Useful today; still not a full jailbreak with a bootstrap. |

## What's in this repo

- `JailbreakHarness/` — a SwiftUI app that walks the five jailbreak stages
  with structured, timestamped logging. Stages 1–2 are real read-only
  device checks. Stage 3 is a documented interface (no exploit code is
  shipped). Stage 4 reports the missing bypass. Stage 5 is gated behind a
  real privileged probe and always skipped. **Terminal state: "Not
  jailbroken."** It also includes a Fastfetch tab.
- `docs/COMPATIBILITY.md` — the evidence table, with sources.
- `docs/ARCHITECTURE.md` — the staged design: how a real chain would fit
  together if/when a public A15 SPTM bypass for iOS 18 appears, including
  the semi-untethered re-run model and the removal story.
- `payload/` — the staged post-exploit layout (OpenSSH configuration
  reference). Inert documentation, not an installer.
- A companion app, [Fastfetch for iOS](https://github.com/c12n/fastfetch),
  ships separately as a normal, working homescreen app.

## Why publish a scaffold that doesn't jailbreak?

Because the honest state of the art is "kernel bug yes, jailbreak no", and
a well-instrumented harness documents exactly where the wall is. If a
public SPTM bypass for A15/iOS 18 is ever released, Stage 4 is the single
integration point.

## Safety

Proof-of-concept research for your own device only. This repository ships
no exploit code and no weaponized payload.

## License

MIT — Copyright (c) 2026 c12n Apps. Upstream projects referenced here keep
their own licenses (ClearSword, Dopamine, Lara — see their repositories).
