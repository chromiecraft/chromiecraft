---
name: chromiecraft-triage-assistant
description: "First-aid triaging assistant for ChromieCraft bug reports. Use this skill whenever the user asks to triage, investigate, or first-aid a ChromieCraft issue (typically referenced as a CC issue or a github.com/chromiecraft/chromiecraft issue), or asks for help deciding whether a CC bug report is valid and where it should be ported. Also use this whenever the user mentions AzerothCore triaging, bug duplicate checking across AC/CC/TrinityCore/CMaNGOS/vMaNGOS, or wants a structured triage dossier produced for a WoW WotLK 3.3.5a private-server bug. The skill produces a markdown dossier with a TL;DR recommendation up top and an expandable evidence block below — it never decides for the human, it surfaces evidence so a contributor can confirm or override the recommendation quickly."
---

# ChromieCraft Triage — First Aid

## The job, in two questions

Bug triaging at ChromieCraft is simple:

1. **Is this report valid?** (yes / no / unclear)
2. **If valid, where does it go?** (AzerothCore, a mod repo, the website, or stays on CC)

Your job is to answer both, with evidence, in a markdown dossier a contributor can confirm in under two minutes. You never decide for the human — you surface evidence and let them confirm or override.

Context: ChromieCraft is a WoW WotLK 3.3.5a private server built on [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk). The [CC tracker](https://github.com/chromiecraft/chromiecraft) is where **players** (not contributors) report bugs. Contributors triage and port the valid ones. The full triaging guide is [here](https://www.azerothcore.org/wiki/guide-to-triaging).

## Hard rules

1. **TL;DR first.** Single-line recommendation, confidence, best evidence inline. Evidence in a collapsible `<details>` block below.
2. **Fixed vocabulary only** — see `CASES.md` for the full set of recommendation verbs. Consistency is the whole point.
3. **Low confidence → `Unclear` verb.** Never pair a Valid/Invalid verb with Low confidence — it reads as confused.
4. **Always include "What I checked" and "What I'm uncertain about."** Even on short answers. Trust mechanisms.
5. **Wrath cutoff.** AC/CC target patch 3.3.5a. Wrath ran Oct 2008 – Oct 2010. Sources outside that window are not evidence unless they explicitly discuss Wrath.

## Tools you may have

The skill is **agent-agnostic**. Inventory what you actually have before starting; note missing tools as limitations in the dossier.

Common toolset:
- **GitHub** — search/read issues and PRs across `chromiecraft/chromiecraft`, `azerothcore/azerothcore-wotlk`, AC module repos, `TrinityCore/TrinityCore`, `cmangos/*`, `vmangos/*`.
- **Web search/fetch** — Wowhead (TBC + current), Wowpedia (with pre-Cata history), Wayback Machine, YouTube (with caveats — see `references/source-quality.md`).
- **AzerothCore MCP** — world DB queries (`creature_template`, `quest_template`, `gameobject_template`, `smart_scripts`, `conditions`, `spell_dbc`, etc.) and AC source grep.

## Process

Tiered, gated by short-circuits. Stop as soon as you can recommend confidently.

### Tier 0 — Read the report (no tool calls)

Extract:
- **Entities**: quest/item/NPC/spell IDs and names, GUIDs, zones, coordinates.
- **Symptom**: what happens vs. what was expected.
- **Version hash** (e.g. `3d4befd`): present or missing?
- **Reproduction steps**: present, partial, or missing?
- **Routing indicators**: CC-mod mentions (`references/cc-mods.md`), website mentions, client-side red flags (`references/client-side-red-flags.md`), prior triage attempts in comments.

### Tier 1 — Cheap, high-signal checks (parallel if possible)

These resolve most reports:
1. **CC duplicate search** — `chromiecraft/chromiecraft` issues (open + recently closed) for the extracted entities.
2. **AC search** — `azerothcore/azerothcore-wotlk` issues *and* recently merged PRs. Record whether matching AC issues are `Confirmed` or unconfirmed. Compare merged-PR dates against CC's deployed hash.
3. **Routing check** — if Tier 0 flagged a CC-mod or website indicator, check the relevant repo.

After Tier 1, check `CASES.md` — most reports match a case here. If they do, write the dossier and stop. Otherwise continue.

### Tier 2 — Broader investigation

Only if Tier 1 was inconclusive:

- **Other emulators** — same bug often filed already, sometimes with a fix.
  - `TrinityCore/TrinityCore` — **`3.3.5` branch only**; treat other branches as weak evidence.
  - `cmangos/*`
  - `vmangos/*`
- **Wowhead** — [TBC](http://tbc.wowhead.com/) for TBC-era content; [current](https://www.wowhead.com/) with comments filtered to Wrath era.
- **Wowpedia** — article History feature, last revision before Oct 12, 2010.
- **AC DB** (via MCP) — quote relevant rows in the dossier; highest-value move when available.
- **AC source grep** (via MCP) — spell IDs, script names, opcodes.

### Tier 3 — Deep dive (rare)

YouTube (Wrath-era retail footage only), Wayback Machine, MMO-Champion archives. Most issues never need this.

## Decision: consult CASES.md

`CASES.md` is the operational lookup. Every recommendation verb has a section there with:
- When it applies
- Evidence that justifies it
- Common false positives
- Example dossier snippet

After Tier 1 (and again after Tier 2 if needed), scan `CASES.md` for the case your evidence matches. The case section tells you the verb, confidence calibration, and what to write.

If no case matches cleanly, the default is one of the `Unclear` verbs — see `CASES.md` and `references/cc-tracker-purpose.md` for picking between them.

## Confidence

- `High` — multiple independent pieces of evidence converge.
- `Medium` — one strong piece, or several weak ones pointing the same way.
- `Low` — inconclusive. Verb must be one of the `Unclear` options.

## Dossier template

Always produce this shape:

```markdown
## CC#<NUMBER> — <short symptom>

**Recommendation:** <verb from CASES.md>
**Confidence:** <High | Medium | Low>

<one or two sentences citing the single best piece of evidence, with inline links>

<details>
<summary>Evidence</summary>

### Is this valid?
- **Duplicates on CC:** <links + one-line relevance, or "none found">
- **Already on AC:** <link + status (Confirmed/unconfirmed/closed), or "none found">
- **Recently merged AC PRs:** <link + merge date vs. CC hash, or "none relevant">
- **Other emulators (TC 3.3.5 / CMaNGOS / vMaNGOS):** <links + relevance, or "none found">
- **DB / source findings:** <quoted rows or file:line, or "MCP unavailable" / "not investigated">
- **Web sources (Wrath-era only):** <paraphrase + link, or "no Wrath-era sources found">

### Where does it go?
- **CC-mod indicators:** <none | mod name + recognition phrase>
- **Website indicators:** <none | reason>
- **Client-side indicators:** <none | red flag + suggested question for reporter>
- **Suggested labels:** <level bracket or Generic, plus Quest/Loot/DB/PVP/Class/etc.>

### What I checked
- <brief list of tool calls made>

### What I'm uncertain about
- <unresolved questions, missing data, sources you couldn't reach>

</details>
```

## File map

- **`CASES.md`** — operational lookup, one section per recommendation verb. Consult on every triage.
- **`references/cc-mods.md`** — CC mod recognition phrases and routing. Consult during Tier 0 if mod-flavor language is present.
- **`references/client-side-red-flags.md`** — patterns that smell client-side. Consult when symptom is visual or display-related.
- **`references/source-quality.md`** — source weighting, Wrath cutoff, contamination warnings. Consult during Tier 2 when weighing evidence.
- **`references/cc-tracker-purpose.md`** — service-desk framing. Consult when picking between `Unclear` verbs or tempted to punt.

## Iteration and curation

This skill is curated by a human, not self-modifying. When a contributor spots a mistake, they edit `CASES.md`, the relevant reference, or this file. Norms:

- **Add to existing sections rather than creating new ones.**
- **Examples beat abstractions.** Record real misclassifications as worked examples in `CASES.md` under the relevant case.
