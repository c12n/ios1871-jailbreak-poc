# Architecture — staged harness design

## Stages

```
[1] Environment     REAL   model / SoC / firmware / kernel version (read-only)
[2] Sandbox check   REAL   jailbreak indicators, sandbox state (read-only)
[3] Kernel exploit  STUB   documented interface to ClearSword upstream;
                           no exploit code ships in this repository
[4] PPL/SPTM bypass FAIL   no public implementation for A15 on iOS 18 —
                           this is the integration point if one appears
[5] Post-exploit    GATED  bootstrap + OpenSSH; runs only after a REAL
                           privileged probe succeeds (open/stat of a
                           root-only path, or effective-uid check after a
                           real operation) — never after a stage-set flag
```

Terminal state is hardcoded: **Not jailbroken** unless a future Stage 4/5
implementation demonstrably changes it. Log lines are timestamped and each
stage reports PASS / FAIL / SKIPPED with a reason; the log is exportable
from the app.

## Semi-untethered model (aspirational)

Dopamine-class jailbreaks are semi-untethered: the app stays installed,
and after every reboot the user re-runs it to re-apply the chain. This
harness follows the same shape — one button, one staged run — so a future
bypass drops into Stage 4 without restructuring the app. Until then the
term describes the design, not a capability.

## Post-exploit layout (staged, inert)

See `payload/README.md`. Summary of what a real Stage 5 would do, in order:

1. Verify root with the privileged probe.
2. Extract a Procursus-style bootstrap to
   `/private/preboot/<boot-manifest-hash>/procursus`, symlink `/var/jb`.
3. Install the `openssh` package from the bootstrap repo; install its
   LaunchDaemon so `sshd` starts on boot (of the jailbroken state).
4. Report the SSH endpoint (port 22) and force a password change from the
   well-known default before declaring success.
5. Install the Fastfetch app as a normal homescreen app (separate IPA in
   the companion repo — an app cannot install another app from inside
   itself on stock iOS).

## Removal

In the harness's reachable states, removal is a **no-op**: nothing is
written outside the app sandbox. A real Stage 5 would need the inverse
routine: stop/remove the SSH daemon, delete the bootstrap directory and
`/var/jb` symlink, reboot to stock. That routine is documented here, not
implemented, because there is nothing for it to undo.
