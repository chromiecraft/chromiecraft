# CASES — Recommendation Lookup

Operational lookup for every recommendation verb, and the **single source of truth for the verb strings**. One section per verb, in three groups: **Valid**, **Invalid**, **Unclear**. Every other document (SKILL.md, the references) must quote these verbs *verbatim* — never paraphrase or invent one.

For each case: when it applies, evidence that justifies it, common false positives, example dossier snippet.

During the routing gate and again after the validity investigation (see SKILL.md "Process"), scan this file for the case your evidence matches. If no case matches cleanly, fall back to one of the `Unclear` verbs.

**The verbs (12):** `Valid — port to AC` · `Valid — port to <mod> repo` · `Valid — Website` · `Invalid — duplicate of <link>` · `Invalid — not a bug` · `Invalid — already fixed` · `Invalid — client-side` · `Invalid — module misconfiguration` · `Invalid — out of scope (not a bug report)` · `Unclear — request more info from reporter` · `Unclear — flag for second opinion / staff review` · `Unclear — close as stale (can be reopened)`.

---

## Valid

Bug is real. Port it somewhere. CC tracker actions vary by destination.

### `Valid — port to AC`

**When it applies:** the bug exists in vanilla AzerothCore (not just on CC), and one of the following holds:
- It is `Confirmed` on an existing AC issue.
- It is filed and/or fixed on the TrinityCore `3.3.5` branch.
- The report is self-evidently a real bug (crash with stack trace, clearly reproducible logic error in quoted source).

**Action by the contributor:**
- If an AC issue already exists → link the CC issue to it. Do **not** file a new one.
- Otherwise → file a new AC issue, link the CC issue to it.

**Evidence that justifies it:**
- Matching `Confirmed` AC issue.
- Matching TC `3.3.5` branch issue/PR.
- Crash trace, error log, or unambiguous symptom in the report.

**False positives — do NOT use this verb when:**
- The AC issue exists but is unconfirmed → use `Unclear — flag for second opinion / staff review`.
- Only a TC master/cata/mop branch issue matches (wrong branch) → keep investigating.
- The bug might be a CC-mod issue or misconfiguration → check the routing-gate indicators first.

**Confidence:** typically `High` (Confirmed elsewhere) or `Medium` (self-evident but unverified).

**Example snippet:**
```
**Recommendation:** Valid — port to AC
**Confidence:** High

This matches AC#5678, which is labeled Confirmed and has matching repro steps for quest 1234.
The CC issue should be linked to AC#5678 rather than creating a new AC ticket.
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
- Mod is fine, CC has it configured wrong → `Invalid — module misconfiguration`.
- Symptom mentions a mod incidentally but the bug is in vanilla behavior → keep investigating.

**Confidence:** `High` if the mod indicator is unambiguous; `Medium` if inferred.

**Example snippet:**
```
**Recommendation:** Valid — port to mod-cfbg repo
**Confidence:** High

The report describes Horde and Alliance players in the same Warsong Gulch — only possible with
CFBG active. The CC issue stays open; the technical fix belongs in mod-cfbg.
```

### `Valid — Website`

**When it applies:** the bug is about the CC website (account portal, donations page, forum, wiki, etc.), not the game server.

**Action by the contributor:**
- Apply the `Website` label.
- Do **not** link to AC.
- CC staff handles website issues separately.

**Evidence that justifies it:**
- Report mentions a chromiecraft.com URL, account registration, donation flow, forum, etc.
- No in-game symptom.

**False positives:**
- Account/login problem that's actually a server-auth bug → keep investigating.
- Website mentions the bug but the bug itself is in-game → not a website bug.

**Confidence:** typically `High` — website vs. in-game is usually unambiguous.

---

## Invalid

Bug is not real on CC. Close the CC issue with the reason.

### `Invalid — duplicate of <link>`

**When it applies:** a CC issue exists with the *same entities and the same symptom*, open or recently closed.

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

**When it applies:** a merged AC PR clearly fixes this issue AND that fix is **actually live on CC now**.

**Determining "live on CC now":** CC's current deployed version is the **HEAD of `chromiecraft/azerothcore-wotlk`** (the authoritative read-only mirror). The fix counts as deployed only if the fixing PR's merge commit is an **ancestor of** that HEAD. The report's own `AC rev. hash` field tells you what the *reporter* was running, not what's live now — do not use it for this test. A merge *date* being earlier than something is **not** evidence of inclusion.

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

### `Invalid — module misconfiguration`

**When it applies:** a CC mod is itself working correctly, but CC has it configured wrong (e.g. wrong `.conf` values, mod enabled in a bracket it shouldn't be).

**Action by the contributor:** close on CC, notify the relevant CC staff member out-of-band if appropriate. Do **not** link to AC. Do **not** file on the mod repo.

**Evidence that justifies it:**
- The mod's documented behavior matches CC's behavior given the current config.
- The bug disappears with default mod config.

**False positives:**
- Actual mod bug → `Valid — port to <mod> repo`.
- Vanilla AC bug that only happens with the mod enabled → keep investigating.

**Confidence:** `High` only if you can clearly identify the misconfigured setting; `Medium` otherwise.

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
reporter to the suggestions channel on Discord.
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

## Worked examples

*(Populate as the curator iterates. Add real misclassifications below the relevant case section above, OR collect them here. Format:)*

```
### Example: CC#<NUM> — <symptom>
**Produced (wrong):** <one-line bad call>
**Should have produced:** <one-line right call>
**Lesson:** <which case section above this strengthens, or new heuristic to add>
```
