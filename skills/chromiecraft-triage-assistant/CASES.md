# CASES — Recommendation Lookup

Operational lookup for every recommendation verb, and the **single source of truth for the verb strings**. One section per verb, in three groups: **Valid**, **Invalid**, **Unclear**. Every other document (SKILL.md, the references) must quote these verbs *verbatim* — never paraphrase or invent one.

For each case: when it applies, evidence that justifies it, common false positives, example dossier snippet.

During the routing gate and again after the validity investigation (see SKILL.md "Process"), scan this file for the case your evidence matches. If no case matches cleanly, fall back to one of the `Unclear` verbs.

**The verbs (11):** `Valid — port to AC` · `Valid — port to <mod> repo` · `Valid — report to CC Staff` · `Invalid — duplicate of <link>` · `Invalid — not a bug` · `Invalid — already fixed` · `Invalid — client-side` · `Invalid — out of scope (not a bug report)` · `Unclear — request more info from reporter` · `Unclear — flag for second opinion / staff review` · `Unclear — close as stale (can be reopened)`.

---

## Valid

Bug is real. Port it somewhere. CC tracker actions vary by destination.

### `Valid — port to AC`

**When it applies:** the report is a **real bug** (a genuine problem players hit on CC) **and** the cause is vanilla AzerothCore behaviour — not a mod, the website, or a CC misconfiguration. Validity is about whether the problem is real; this verb is the *routing* decision that the fix belongs in AC main. Signals that point here:
- A matching AC issue already exists — `Confirmed` (strongest) or even unconfirmed (someone else hit it too, which already raises the odds the bug is real).
- The same bug is filed and/or fixed on a similar project — TrinityCore (`3.3.5` branch), cmangos-wotlk, etc.
- The report is self-evidently a real bug: clear, reproducible steps plus a credible Wrath-era source showing the behaviour should differ. Remember reports come from **players, not developers** — expect repro steps, screenshots, videos, and Wowhead/Wowpedia links, *not* stack traces, logs, or code.

**Action by the contributor:**
- If an AC issue already exists → link the CC issue to it. Leave a comment on the AC issue to confirm it. Do **not** file a new one.
- Otherwise → file a new AC issue, link the CC issue to it.

**Evidence that justifies it (each piece raises confidence — they stack):**
- A matching AC issue. `Confirmed` is strongest; **unconfirmed is still positive** — it means others hit the same bug, which is more reassuring than no AC issue at all.
- A matching issue/PR on a similar project. TC `3.3.5` branch (or comparable) is strongest.
- A clear, reproducible player-described symptom backed by a credible Wrath-era source.

**False positives — do NOT use this verb when:**
- The cause is actually a CC mod → `Valid — port to <mod> repo`. (Still a valid report — just a different destination.)
- The cause is a CC misconfiguration → route to CC Staff (see the misconfiguration case). (Still a valid report — just a different destination.)
- The only match is on a **non-`3.3.5`** branch of another project (e.g. TC master/cata): treat it as *weak* evidence — behaviour can differ across expansions, so it raises suspicion but doesn't by itself confirm a 3.3.5a bug. Keep weighing other signals; don't discard it either.

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

**Action by the contributor:**
- Link/file the issue on the mod's repo (e.g. `azerothcore/mod-cfbg`).
- Leave the CC issue open with a link to the mod repo.

**Evidence that justifies it:**
- The routing gate flagged a CC-mod indicator (see `references/cc-mods.md`).
- Reproduction depends on the mod being active.
- The symptom only makes sense in the mod's context (cross-faction, low-level arena, etc.).

**False positives:**
- Mod is fine, CC has it configured wrong → `Valid — report to CC Staff` (a misconfiguration: still a valid report, just routed to CC Staff instead of the mod repo).
- Symptom mentions a mod incidentally but the bug is in vanilla behavior → keep investigating.

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

**When it applies:** the report is a **real problem**, but the fix is neither AC's nor a mod repo's — CC Staff handles it out-of-band. Two cases (name which one in the dossier sentence):
- **Website** — the bug is about the CC website (account portal, donations page, forum, wiki, a chromiecraft.com URL), not the game server.
- **Module misconfiguration** — a CC mod itself works correctly, but CC has it configured wrong (wrong `.conf` values, a mod enabled in a bracket it shouldn't be). Rare, but it happens — and it's a *real* problem for the player, so the report is **valid**, not invalid.

**Action by the contributor:**
- **Website:** apply the `Website` label and report it to CC Staff on Discord; the web team takes it from there. Do **not** link to AC.
- **Misconfiguration:** report the wrong setting to CC Staff out-of-band, then close the CC issue. Do **not** link to AC; do **not** file on the mod repo.

**Evidence that justifies it:**
- *Website:* a chromiecraft.com URL, account registration, donation flow, forum, etc.; no in-game symptom. (Arrival via `web_bug_report.yml` is a strong signal.)
- *Misconfiguration:* the mod's documented behaviour matches CC's behaviour given the current config; the bug disappears under default mod config.

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

**"Invalid" here means "close the CC issue" — not necessarily "the bug isn't real."** Two kinds live in this group: the report isn't a real problem (`not a bug`, `out of scope`), **or** the bug may well be real but there's nothing further for CC to do (`duplicate` — already tracked on CC; `already fixed` — already resolved; `client-side` — not fixable server-side). Either way, the CC issue is closed with the reason.

### `Invalid — duplicate of <link>`

**When it applies:** another CC issue already describes the **same problem**, open or recently closed. ("Same problem" — the same underlying bug — not merely the same entity; see false positives.)

**CC-internal only.** "Duplicate" means *another **CC** report* for the same problem (players are expected to search CC before filing). A matching report on **AC or a similar project is NOT a duplicate** — it's *positive* evidence the bug is real and routes to `Valid — port to AC`, not here. The `<link>` in this verb is always a CC issue.

**Action by the contributor:** close the CC issue, linking the original.

**Evidence that justifies it:**
- Same quest/item/NPC/spell ID and same described symptom.
- Reporter phrasing often overlaps with the original — sometimes verbatim.

**False positives — do NOT call duplicate when:**
- Title looks similar but entities differ.
- Same entity but different symptom (e.g. both about NPC X, but one is "wrong faction" and one is "missing gossip option").
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

**When it applies:** the reported behavior is actually correct per 3.3.5a / Wrath-era sources, or the reporter misunderstood game mechanics.

**Action by the contributor:** close with an explanation citing the source.

**Evidence that justifies it:**
- Wrath-era Wowhead/Wowpedia/sniff sources confirm the behavior is intended.
- AC DB matches the expected configuration.
- Reporter's expectation is based on Classic, TBC, or post-Cata behavior (out of scope).

**False positives:**
- "It works this way" with no source → not enough; investigate further.
- A Wowhead comment alone (especially post-2010) → weak; cross-reference.

**Confidence:** `High` only with multiple Wrath-era sources or DB confirmation; otherwise `Medium`.

### `Invalid — already fixed`

**When it applies:** a recently merged AC PR clearly fixes this issue AND that fix is **actually live on CC now**.

**Determining "live on CC now":** CC's current deployed version is the **HEAD of `chromiecraft/azerothcore-wotlk`** (the authoritative read-only mirror).
The fix counts as deployed only if the fixing PR's merge commit is an **ancestor of** that HEAD.
The report's own `AC rev. hash` field tells you what the *reporter* was running, not what's live now — do not use it for this test.
A merge *date* being earlier than something is **not** evidence of inclusion.

**Action by the contributor:** close, linking the AC PR.

**Evidence that justifies it:**
- AC PR exists, is merged, and addresses the reported symptom.
- The PR's merge commit is an ancestor of CC's deployed `chromiecraft/azerothcore-wotlk` HEAD.

**False positives — do NOT use this verb when:**
- The fix is **not** an ancestor of CC's deployed HEAD → the bug can still legitimately appear on CC. Do **not** short-circuit; treat as if the fix doesn't exist yet for CC.
- PR is merged but doesn't actually fix the reported scenario (only a related case).
- You cannot determine CC's deployed HEAD (mirror unreachable) → don't guess; this becomes an `Unclear` call.

**Confidence:** `High` only when the PR diff clearly covers the symptom *and* you confirmed ancestry; `Medium` otherwise.

### `Invalid — client-side`

**When it applies:** the symptom is purely client-side (display, tooltip, model, texture, UI) — not fixable by the server.

**Action by the contributor:** close, explaining it's a client-side issue.

**Evidence that justifies it:**
- Reporter has already confirmed running graphics mods or non-enUS locale.
- The symptom is visual-only with no gameplay effect (e.g. wrong tooltip value but correct actual outcome).
- AC DB confirms the underlying data is correct.

**False positives:**
- Visual symptom without confirmation from reporter → use `Unclear — request more info from reporter` first.
- Symptom looks visual but reflects real DB data (e.g. NPC's actual faction is wrong) → not client-side.

**Confidence:** `High` only after reporter confirmation; `Medium` if DB confirms data is correct but reporter hasn't responded.

### `Invalid — out of scope (not a bug report)`

**When it applies:** the report is not a bug at all — it's a feature request / suggestion ("mounts should be account-wide"), a question ("how do I get to Naxxramas?"), or a balance complaint ("this boss is too hard"). The tracker is for bug reports; these belong elsewhere.

**Distinguish from `Invalid — not a bug`:** `not a bug` means the reported behaviour *is a real in-game behaviour that is actually correct* per Wrath-era sources (the reporter misunderstood mechanics). `out of scope` means there is *no bug being reported in the first place*. Different reply, different evidence.

**Action by the contributor:** close politely, redirecting the reporter to the right channel (e.g. Discord / suggestions). Do **not** link to AC.

**Evidence that justifies it:**
- The report asks for new/changed behaviour rather than describing something broken.
- It's a question or a "please make X easier/harder" balance opinion.
- No description of a malfunction vs. expected 3.3.5a behaviour.

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

**When it applies:** the report is missing information the bot or a human triager would need to decide. This is for **fresh** reports that haven't been asked for info before.

**Action by the contributor:** comment on the CC issue asking the specific questions; tag as "Waiting for Feedback" per the triaging guide.

**Evidence that justifies it:**
- Missing version hash.
- Missing reproduction steps or unclear symptom.
- Visual-only symptom without locale/mods confirmation.
- Vague entity references ("the NPC in Stormwind" — which one?).

**False positives — do NOT use this verb when:**
- Reporter has already been asked once and didn't respond meaningfully → `Unclear — close as stale`.
- The report is detailed enough to investigate; the bot just hit a tool limitation → that's `Unclear — flag for second opinion / staff review` instead.

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

**When it applies:** the report is detailed enough to investigate, the bot found *some* evidence but not enough to conclude, and no prior triage attempt has failed. Often signals that human eyes need to look — possibly with tools the bot lacks (PTR access, in-game repro).

**Action by the contributor:** tag the CC issue as `Needs second opinion` or `Needs staff review` per the triaging guide.

**Evidence that justifies it:**
- AC issue exists but is unconfirmed → can't port to AC yet, can't close either.
- TC/CMaNGOS/vMaNGOS hits exist but conflict.
- DB looks suspicious but not clearly wrong.
- The bot's tools couldn't reach a relevant source (e.g. MCP unavailable for a DB-dependent question).

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

**Action by the contributor:** close with a note explaining the report can be reopened with new info.

**Evidence that justifies it:**
- Prior comments asking for more info that went unanswered.
- Prior triage attempts that reached no conclusion.
- The report has been open a long time with no progress.

**False positives:**
- Fresh report that's just hard → `Unclear — flag for second opinion / staff review`.
- Reporter is actively engaged and a question is pending → `Unclear — request more info from reporter` (or wait).

**Confidence:** typically `Medium` — you're making a deliberate call to clear limbo, not a confident verdict on the underlying bug.

**Example snippet:**
```
**Recommendation:** Unclear — close as stale (can be reopened)
**Confidence:** Medium

Two prior triage attempts (5 and 8 months ago) couldn't reproduce. Reporter hasn't responded
to follow-up questions. Closing as stale per the CC tracker service-desk framing — can be
reopened if new repro info appears.
```

---
