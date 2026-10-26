# Compatibility — iPhone 14 (A15) · iOS 18.7.1

Checked 2026-10-26 against the projects' own repositories and changelogs.

## The chain a modern jailbreak needs

1. **Kernel exploit** → arbitrary kernel read/write.
2. **PPL/SPTM bypass** → defeat Page Protection Layer / Secure Page Table
   Monitor restrictions so the kernel primitives can be turned into
   process/task manipulation on arm64e.
3. **Post-exploitation** → sandbox escape, code-signing (AMFI) handling,
   root credentials.
4. **Bootstrap** → install a package environment (Procursus on Dopamine)
   under `/private/preboot/<hash>/procursus`, symlinked at `/var/jb`.
5. **Persistence model** → semi-untethered: after a reboot, re-running the
   app re-applies stages 1–4. Nothing survives a reboot by itself.

## Where each stage stands for A15 + 18.7.1

### 1. Kernel exploit — available
- CVE-2025-43520: race in XNU `cluster_write_contig` / `cluster_read_contig`
  (the kernel stage of the DarkSword chain). Patched in iOS 18.7.2, so
  18.7.1 is the last vulnerable 18.x release.
- ClearSword (TheRealClarity) reimplements it in C for use from a native
  app and reports support across iOS 15–26.0.1 with per-version offsets.
- Dopamine 3 ships it (as ClearSword, with DarkSword as the alternative)
  and opa334 maintains an Objective-C port (`darksword-kexploit`).

### 2. PPL/SPTM bypass — **not available for this device/firmware**
- Dopamine 3.0 changelog: the *Titan* bypass covers 16.5.1–17.3.1 on all
  devices; the *momentarius* bypass covers **A12/A13 only** on
  16.6–18.7.1 and 26.0–26.0.1.
- The same changelog states SPTM-device support on real hardware stops at
  17.3.1 "due to lack of an SPTM bypass on >= 17.4".
- Dopamine's README summarizes support as: iOS 15.0–17.3.1 (arm64e),
  15.0–18.7.1 + 26.0–26.0.1 (A12/A13), 15.0–18.7.1 (arm64).
- iPhone 14 is A15/arm64e → its ceiling with Dopamine 3 is **17.3.1**.

### 3–5. Post-exploitation, bootstrap, OpenSSH — unreachable without (2)
- OpenSSH on jailbroken iOS is normally the Procursus `openssh` package,
  run as a LaunchDaemon from the bootstrap, listening on port 22 with
  `root` / `mobile` accounts (default password `alpine` — change it
  immediately on any real jailbreak). None of that can be installed or
  started without stages 2–3.

## What does work on A15 + 18.7.1 today

- **Lara** (rooootdev/lara, AGPL-3.0): customization toolbox on the same
  kernel exploit — full-disk file manager, MobileGestalt editor, font/card
  overwrites, JIT enabler, app decrypt. It demonstrates kernel-level
  access without claiming a bootstrap jailbreak.
- **This harness**: read-only verification of device/firmware, structured
  stage logging, and Fastfetch system info.

## Sources

- Dopamine — https://github.com/opa334/Dopamine (README + 3.0 changelog)
- ClearSword — https://github.com/TheRealClarity/ClearSword and the
  author's write-up, "Into the Dark — DarkSword Kernel Exploit Writeup"
- Lara — https://github.com/rooootdev/lara (Support table: 17.0–18.7.1
  supported, 18.7.2+ not supported)
- Google Threat Intelligence Group / iVerify / Lookout reporting on the
  DarkSword chain (March 2026 disclosure; patched in 18.7.2 / 26.1)
