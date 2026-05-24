# CC Tracker — Purpose and Service-Desk Framing

This file captures the philosophy of the CC issue tracker. Consult it when deciding *whether* to forward, close, or keep open — the framing matters more than any specific rule.

## What the CC tracker IS

A **service desk** bridging players and contributors. Players (not contributors) report problems they hit while playing. Contributors triage and route. Every report should get one of these answers, ideally within a reasonable time:

1. **Yes, we'll fix this** → forward to AC (only when bug is confirmed real)
2. **No, this isn't valid** → close with reason
3. **We need more info from you** → request and tag accordingly
4. **We'll have a look and decide** → keep open with appropriate tag (e.g. `Needs second opinion`, `Needs staff review`)

## What the CC tracker is NOT

- **Not a research forum.** Technical discussions about code, fixes, implementation belong on AC.
- **Not a parking lot.** Reports lingering with "incomplete information" or "nobody investigated" indefinitely are a triage failure.
- **Not for contributors to report their own bugs.** Contributors are expected to triage themselves first, on PTR or local AC, and file directly on AC if confirmed.
- **Not for things AC handles.** Anything that's purely an AC concern goes to AC.

## Implications for the bot

### Bias toward making a call

A clear "close as stale" beats an indefinite "needs more investigation." The report can always be reopened if new information appears. Limbo helps no one.

### Forwarding to AC: link freely, file carefully

Two different actions, two different bars:
- **An AC issue already exists** (`Confirmed` *or* unconfirmed) → linking the CC issue to it is always fine. An existing AC report — even unconfirmed — *raises* confidence the bug is real (someone else hit it). A `Confirmed` one is strongest; if a contributor can reproduce an unconfirmed one, they should confirm it on AC.
- **No AC issue exists yet** → filing a *new* AC issue is a higher bar: do it when the report is self-evidently a real bug (clear, reproducible **player** steps backed by a Wrath-era source) or matches a similar project (TC `3.3.5`, etc.). A bare "might be a bug" with nothing behind it does **not** earn a new AC issue — it stays on CC as `Unclear — flag for second opinion / staff review` (fresh) or `Unclear — close as stale (can be reopened)` (already tried).

(Reports come from **players, not developers** — expect repro steps, screenshots, videos, Wowhead/Wowpedia links, never stack traces or code.)

### Categories of "stay on CC" or "don't go to AC"

- **CC-mod bugs:** stay on CC, link to mod repo. Mod maintainers fix.
- **Website bugs:** `Valid — report to CC Staff` — apply the `Website` label; the web team handles it.
- **Module misconfiguration:** `Valid — report to CC Staff` — a real problem for the player; report the setting to CC Staff (not AC, not the mod repo).
- **Client-side issues:** close (after confirming locale/mods with reporter).
- **Inconclusive after fair attempt:** `Unclear — close as stale (can be reopened)`.
- **Not a bug report (feature request / question / balance):** `Invalid — out of scope (not a bug report)`. Redirect to the right channel.

### Tag signals to watch for

Reports tagged `Needs second opinion` or `Needs staff review` are explicit asks for human escalation. The bot should still produce its dossier, but the recommendation should reflect that staff attention has already been requested — don't recommend the same tag again unless there's a new reason.

## When in doubt

Close > pending. A closed issue with a clear reason can be reopened. A pending issue with no progress wastes everyone's time and clutters the queue.

## Curator notes

If this framing drifts in practice (e.g. the bot starts recommending "needs investigation" too freely, or forwarding unconfirmed bugs to AC), strengthen the relevant section here rather than scattering reminders across SKILL.md.
