# CASES — Recommendation Lookup

Operational lookup for every recommendation verb, and the **single source of truth for the verb strings**. One section per verb, in three groups: **Valid**, **Invalid**, **Unclear**. Every other document (SKILL.md, the references) must quote these verbs *verbatim* — never paraphrase or invent one.

For each case: when it applies, the evidence that justifies it, common false positives, an example snippet.

During the routing gate and again after the validity investigation (see SKILL.md "Process"), scan this file for the case your evidence matches. If no case matches cleanly, fall back to one of the `Unclear` verbs.

**The verbs (11):** `Valid — port to AC` · `Valid — port to <mod> repo` · `Valid — report to CC Staff` · `Invalid — duplicate of <link>` · `Invalid — not a bug` · `Invalid — already fixed` · `Invalid — client-side` · `Invalid — out of scope (not a bug report)` · `Unclear — request more info from reporter` · `Unclear — flag for second opinion / staff review` · `Unclear — close as stale (can be reopened)`.

---

## Valid

Bug is real. Port it somewhere. CC tracker actions vary by destination.

### `Valid — port to AC`

**When it applies:** the report is a **real bug** (a genuine problem players hit on CC) **and** the cause is vanilla AzerothCore — not a mod, the website, or a CC misconfiguration. Validity is whether the problem is real; this verb is the *routing* call that the fix belongs in AC main.

**Evidence (each piece raises confidence — they stack):**
- A matching **AC issue**: `Confirmed` is strongest, but **unconfirmed is still positive** — it means others hit the same bug, more reassuring than no AC issue at all.
- The same bug **filed and/or fixed** on a **similar project**: TC `3.3.5` branch (strongest), cmangos-wotlk, etc. A fix existing elsewhere is itself evidence.
- A **self-evidently real** report: clear, reproducible steps plus a credible Wrath-era source showing the behaviour should differ. Reports come from **players, not developers** — expect repro steps, screenshots, videos, Wowhead/Wowpedia links, *not* stack traces, logs, or code.

**Action by the contributor:**
- An AC issue already exists → link the CC issue to it and comment there to confirm. Do **not** file a new one.
- Otherwise → file a new AC issue, link the CC issue to it.

**False positives — do NOT use this verb when:**
- The cause is a CC mod → `Valid — port to <mod> repo`. (Still valid — different destination.)
- The cause is a CC misconfiguration → `Valid — report to CC Staff`. (Still valid — different destination.)
- The only match is on a **non-`3.3.5`** branch (e.g. TC master/cata): treat it as *weak* evidence — behaviour can differ across expansions, so it raises suspicion but doesn't confirm a 3.3.5a bug. Keep weighing other signals; don't discard it either.

**Confidence:** `High` with a `Confirmed` AC issue or strong converging evidence; `Medium` for an unconfirmed match or a self-evident but unverified report.

**Example snippet:**
```
**Recommendation:** Valid — port to AC
**Confidence:** High

This matches AC#5678 (Confirmed), with repro steps for quest 1234 that mirror this report.
Link the CC issue to AC#5678 rather than opening a new one. (If AC#5678 were unconfirmed it would
still be good news — a contributor who can reproduce the bug should confirm it there.)
```

### `Valid — port to <mod> repo`

**When it applies:** the bug is in a CC-specific mod (not vanilla AC) and is a real bug (not misconfiguration). The CC issue stays open — it's a valid CC bug; the mod repo gets the technical fix.

**Evidence that justifies it:**
- The routing gate flagged a CC-mod indicator (see `references/cc-mods.md`).
- Reproduction depends on the mod being active.
- The symptom only makes sense in the mod's context (cross-faction, low-level arena, etc.).

**Action by the contributor:** link/file the issue on the mod's repo (e.g. `azerothcore/mod-cfbg`); leave the CC issue open with a link to it.

**False positives:**
- Mod is fine, CC has it configured wrong → `Valid — report to CC Staff` (a misconfiguration, just routed to CC Staff instead of the mod repo).
- Symptom mentions a mod incidentally but the bug is in vanilla behaviour → keep investigating.

**Confidence:** `High` if the mod indicator is unambiguous; `Medium` if inferred.

**Example snippet:**
```
**Recommendation:** Valid — port to mod-cfbg repo
**Confidence:** High

In a cross-faction Warsong Gulch (CFBG is always on for CC), the reporter's same-team allies of the
opposite faction don't receive group-wide buffs — an interaction that only exists because CFBG mixes
factions. The fix belongs in mod-cfbg; the CC issue stays open, linked to the mod repo.
```

### `Valid — report to CC Staff`

**When it applies:** the report is a **real problem**, but the fix is neither AC's nor a mod repo's — CC Staff handles it out-of-band. Two cases (name which in the dossier sentence):
- **Website** — the bug is about the CC website (account portal, donations, forum, wiki, a chromiecraft.com URL), not the game server. Arrival via `web_bug_report.yml` is a strong signal; sanity-check there's no in-game symptom.
- **Module misconfiguration** — a CC mod works correctly but CC has it configured wrong (wrong `.conf` values, a mod enabled in a bracket it shouldn't be). Rare, but a *real* problem for the player, so the report is **valid**, not invalid. Confirm by: the mod's documented behaviour matches CC's behaviour under the current config, and the bug disappears under default mod config.

**Action by the contributor:**
- **Website:** apply the `Website` label and report to CC Staff on Discord; the web team takes it from there. Do **not** link to AC.
- **Misconfiguration:** report the wrong setting to CC Staff out-of-band, then close the CC issue. Do **not** link to AC; do **not** file on the mod repo.

**False positives:**
- Account/login problem that's actually a server-auth bug → not a website issue; keep investigating.
- An actual mod *bug* (not config) → `Valid — port to <mod> repo`.
- A vanilla AC bug that merely surfaces with a mod enabled → `Valid — port to AC`; keep investigating.

**Confidence:** `High` for website (website vs. in-game is usually unambiguous) and for misconfiguration when you can name the wrong setting; `Medium` otherwise.

**Example snippet:**
```
**Recommendation:** Valid — report to CC Staff
**Confidence:** High

This is a website bug — the donations page returns a 500, with no in-game symptom (filed via the
web report template). Apply the `Website` label and flag CC Staff on Discord; do not link to AC.
```

---

## Invalid

**"Invalid" means "close the CC issue" — not necessarily "the bug isn't real."** Two kinds live here: the report isn't a real problem (`not a bug`, `out of scope`), **or** the bug may well be real but there's nothing further for CC to do (`duplicate` — already tracked on CC; `already fixed` — already resolved; `client-side` — not fixable server-side). Either way, close the CC issue with the reason.

### `Invalid — duplicate of <link>`

**When it applies:** another CC issue already describes the **same problem** (the same underlying bug — not merely the same entity; see false positives), open or recently closed.

**CC-internal only.** "Duplicate" means *another **CC** report* (players are expected to search CC before filing). A matching report on **AC or a similar project is NOT a duplicate** — it's *positive* evidence the bug is real and routes to `Valid — port to AC`. The `<link>` here is always a CC issue.

**Evidence that justifies it:** same quest/item/NPC/spell ID **and** same described symptom; reporter phrasing often overlaps with the original, sometimes verbatim.

**Action by the contributor:** close the CC issue, linking the original.

**False positives — do NOT call duplicate when:**
- Title looks similar but entities differ.
- Same entity but different symptom (both about NPC X, but one is "wrong faction" and one is "missing gossip option").
- The "duplicate" was closed years ago with no resolution and no clear reason → may be stale rather than duplicate; consult.

**Confidence:** `High` if entities + symptom both match; `Medium` if one strongly matches and the other is plausible.

**Example snippet:**
```
**Recommendation:** Invalid — duplicate of CC#1100
**Confidence:** High

CC#1100 (open, 4 months) reports the same NPC failing the same quest's turn-in with matching
phrasing. This report adds no new information.
```

### `Invalid — not a bug`

**When it applies:** the reported behaviour is actually correct per 3.3.5a / Wrath-era sources, or the reporter misunderstood game mechanics.

**Evidence that justifies it:**
- Wrath-era Wowhead/Wowpedia/sniff sources confirm the behaviour is intended.
- AC DB matches the expected configuration.
- Reporter's expectation is based on Classic, TBC, or post-Cata behaviour (out of scope).

**Action by the contributor:** close with an explanation citing the source.

**False positives:**
- "It works this way" with no source → not enough; investigate further.
- A Wowhead comment alone (especially post-2010) → weak; cross-reference.

**Confidence:** `High` only with multiple Wrath-era sources or DB confirmation; otherwise `Medium`.

### `Invalid — already fixed`

**When it applies:** a recently merged AC PR clearly fixes this issue AND that fix is **actually live on CC now**. This is the single source of truth for the "live on CC" test, referenced from SKILL.md:

> CC's current deployed version is the **HEAD of `chromiecraft/azerothcore-wotlk`** (the authoritative read-only mirror). The fix counts as deployed only if the fixing PR's merge commit is an **ancestor of** that HEAD. The report's own `AC rev. hash` tells you what the *reporter* was running, not what's live now — do not use it for this test. A merge *date* being earlier than something is **not** evidence of inclusion.

**Evidence that justifies it:** AC PR exists, is merged, addresses the reported symptom, and its merge commit is an ancestor of CC's deployed HEAD.

**Action by the contributor:** close, linking the AC PR.

**False positives — do NOT use this verb when:**
- The fix is **not** an ancestor of CC's deployed HEAD → the bug can still legitimately appear on CC. Do **not** short-circuit; treat as if the fix doesn't exist yet for CC.
- PR is merged but doesn't actually fix the reported scenario (only a related case).
- You cannot determine CC's deployed HEAD (mirror unreachable) → don't guess; this becomes an `Unclear` call.

**Confidence:** `High` only when the PR diff clearly covers the symptom *and* you confirmed ancestry; `Medium` otherwise.

### `Invalid — client-side`

**When it applies:** the symptom is purely client-side (display, tooltip, model, texture, UI) — not fixable by the server. See `references/client-side-red-flags.md`.

**Evidence that justifies it:**
- Reporter has already confirmed running graphics mods or a non-enUS locale.
- The symptom is visual-only with no gameplay effect (e.g. wrong tooltip value but correct actual outcome).
- AC DB confirms the underlying data is correct.

**Action by the contributor:** close, explaining it's a client-side issue.

**False positives:**
- Visual symptom without confirmation from reporter → use `Unclear — request more info from reporter` first.
- Symptom looks visual but reflects real DB data (e.g. NPC's actual faction is wrong) → not client-side.

**Confidence:** `High` only after reporter confirmation; `Medium` if DB confirms data is correct but reporter hasn't responded.

### `Invalid — out of scope (not a bug report)`

**When it applies:** the report is not a bug at all — a feature request / suggestion ("mounts should be account-wide"), a question ("how do I get to Naxxramas?"), or a balance complaint ("this boss is too hard"). The tracker is for bug reports; these belong elsewhere.

**Distinguish from `Invalid — not a bug`:** `not a bug` means the reported behaviour *is a real in-game behaviour that is actually correct* per Wrath-era sources (reporter misunderstood mechanics). `out of scope` means there is *no bug being reported in the first place*. Different reply, different evidence.

**Evidence that justifies it:**
- The report asks for new/changed behaviour rather than describing something broken.
- It's a question, or a "please make X easier/harder" balance opinion.
- No description of a malfunction vs. expected 3.3.5a behaviour.

**Action by the contributor:** close politely, redirecting the reporter to the right channel (e.g. Discord / suggestions). Do **not** link to AC.

**False positives:**
- A balance complaint that actually points at a real DB/mechanic error (e.g. a boss with the wrong health value) → that *is* a bug; investigate.
- "It should work like retail-now" → that's `Invalid — not a bug` (out-of-patch expectation), not out of scope.

**Confidence:** typically `High` — bug-report vs. not is usually clear. Lower it if the report is ambiguous between a suggestion and a real defect.

**Example snippet:**
```
**Recommendation:** Invalid — out of scope (not a bug report)
**Confidence:** High

This is a feature request (account-wide mounts), not a bug. Suggest closing and redirecting the
reporter to the suggestions channel on Discord or https://github.com/orgs/chromiecraft/discussions
```

---

## Unclear

Cannot determine validity yet. The CC tracker is a service desk — pick one of these three deliberately, don't default to "investigate more." See `references/cc-tracker-purpose.md`.

### `Unclear — request more info from reporter`

**When it applies:** a **fresh** report (not asked for info before) missing information the bot or a human triager would need to decide.

**Evidence that justifies it:** missing version hash; missing repro steps or unclear symptom; visual-only symptom without locale/mods confirmation; vague entity references ("the NPC in Stormwind" — which one?).

**Action by the contributor:** comment on the CC issue asking the specific questions; tag as "Waiting for Feedback" per the triaging guide.

**False positives — do NOT use this verb when:**
- Reporter has already been asked once and didn't respond meaningfully → `Unclear — close as stale`.
- The report is detailed enough to investigate; the bot just hit a tool limitation → `Unclear — flag for second opinion / staff review`.

**Confidence:** typically `Low` (you're explicitly asking because you don't know).

**Example snippet:**
```
**Recommendation:** Unclear — request more info from reporter
**Confidence:** Low

The report describes a tooltip showing wrong damage, but doesn't specify client locale or
whether any graphics/UI mods are installed. Ask the reporter:
- Which client locale (enUS / enGB / other)?
- Any UI mods installed?
- Does the actual damage match the tooltip, or only the display is wrong?
```

### `Unclear — flag for second opinion / staff review`

**When it applies:** the report is detailed enough to investigate, the bot found *some* evidence but not enough to conclude, and no prior triage attempt has failed. Often signals that human eyes are needed — possibly with tools the bot lacks (PTR access, in-game repro).

**Evidence that justifies it:** an AC issue exists but is unconfirmed (can't port yet, can't close); TC/CMaNGOS/vMaNGOS hits conflict; DB looks suspicious but not clearly wrong; the bot's tools couldn't reach a relevant source (e.g. MCP unavailable for a DB-dependent question).

**Action by the contributor:** tag the CC issue `Needs second opinion` or `Needs staff review` per the triaging guide.

**False positives:**
- Already tried before with the same outcome → `Unclear — close as stale`.
- Just needs a question answered by the reporter → `Unclear — request more info from reporter`.

**Confidence:** typically `Low` (by definition you're escalating because you don't know).

**Example snippet:**
```
**Recommendation:** Unclear — flag for second opinion / staff review
**Confidence:** Low

AC#5678 matches the symptom but is unconfirmed (no repro confirmation in 6 months). TC has
a similar 3.3.5 issue closed without resolution. DB data looks plausible but the smart_scripts
chain is complex — recommend a human with PTR access verify.
```

### `Unclear — close as stale (can be reopened)`

**When it applies:** the report has prior triage comments showing previous attempts that couldn't resolve it. Limbo is a failure mode; closing is the safe action — the report can be reopened if new information appears.

**Evidence that justifies it:** prior comments asking for more info that went unanswered; prior triage attempts that reached no conclusion; open a long time with no progress.

**Action by the contributor:** close with a note explaining the report can be reopened with new info.

**False positives:**
- Fresh report that's just hard → `Unclear — flag for second opinion / staff review`.
- Reporter is actively engaged and a question is pending → `Unclear — request more info from reporter` (or wait).

**Confidence:** typically `Medium` — a deliberate call to clear limbo, not a confident verdict on the underlying bug.

**Example snippet:**
```
**Recommendation:** Unclear — close as stale (can be reopened)
**Confidence:** Medium

Two prior triage attempts (5 and 8 months ago) couldn't reproduce. Reporter hasn't responded
to follow-up questions. Closing as stale per the CC tracker service-desk framing — can be
reopened if new repro info appears.
```

---
