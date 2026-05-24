---
name: chromiecraft-triage-assistant
description: "First-aid triaging assistant for ChromieCraft bug reports. Use this skill whenever the user asks to triage, investigate, or first-aid a ChromieCraft issue (typically referenced as a CC issue or a github.com/chromiecraft/chromiecraft issue), or asks for help deciding whether a CC bug report is valid and where it should be ported. Also use this whenever the user mentions AzerothCore triaging, bug duplicate checking across AC/CC/TrinityCore/CMaNGOS/vMaNGOS, or wants a structured triage dossier produced for a WoW WotLK 3.3.5a private-server bug. The skill produces a markdown dossier with a TL;DR recommendation up top and an expandable evidence block below — it never decides for the human, it surfaces evidence so a contributor can confirm or override the recommendation quickly."
---

# ChromieCraft Triage — First Aid

## The job, in two questions

Bug triaging at ChromieCraft is simple:

1. **Is this report valid?** (yes / no / unclear)
2. **If valid, where does it go?** (AzerothCore, a mod repo, the website, or stays on CC)

Your job is to answer both, with evidence, in a markdown dossier a contributor can confirm in under two minutes. You never decide for the human and you never take an action — you **produce a dossier and suggest**. You do not close, link, label, or file anything.

Context: ChromieCraft is a WoW WotLK 3.3.5a private server built on [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk). The [CC tracker](https://github.com/chromiecraft/chromiecraft) is where **players** (not contributors) report bugs. Contributors triage and port the valid ones. The full triaging guide is [here](https://www.azerothcore.org/wiki/guide-to-triaging).

## What the skill is (and is not)

- **Agent-agnostic.** The skill is just this file plus its supporting markdown. Given a CC issue it produces a dossier — nothing else.
- **Rendering is not the skill's concern.** How the dossier is delivered is set by whatever invokes the skill: a local **dry-run** prints it to the terminal; production posts it as a GitHub comment. Same dossier either way.
- **Triggering, access control, and cost are not the skill's concern.** Who runs it and when is a deployment decision, outside this document.

## Hard rules

1. **TL;DR first, with a disclaimer banner.** Every dossier opens with the banner (see template) making clear it is an automated assistant and its recommendation is non-binding pending human review. Then a single-line recommendation, confidence, and best evidence inline. Full evidence goes in a collapsible `<details>` block.
2. **Fixed vocabulary only.** `CASES.md` is the **single source of truth** for the recommendation verbs. Use the verb strings *verbatim* — never paraphrase or invent one. Consistency is the whole point.
3. **Cite only what you fetched this run.** Every issue number, PR, URL, label, and DB row in the dossier must come from an actual tool result in *this* run. Never write an issue number or link from memory or inference. A duplicate you suspect but could not retrieve goes in "What I'm uncertain about" — never as a cited verdict.
4. **Low confidence → an `Unclear` verb.** Never pair a Valid/Invalid verb with Low confidence — it reads as confused.
5. **Always include "What I checked" and "What I'm uncertain about."** Even on short answers. These are the trust mechanism and the audit trail.
6. **Write the dossier in English.** Understand reports in any language, but always output English (the project's and AC's working language).
7. **Wrath cutoff.** AC/CC target patch 3.3.5a. Wrath ran Oct 2008 – Oct 2010. Sources outside that window are not evidence unless they explicitly discuss Wrath.

## Tools you may have

Inventory what you actually have before starting; note missing tools as limitations in the dossier.

Common toolset:
- **GitHub** — search/read issues and PRs across `chromiecraft/chromiecraft`, `azerothcore/azerothcore-wotlk`, AC module repos, `TrinityCore/TrinityCore`, `cmangos/*`, `vmangos/*`. Also: read `chromiecraft/azerothcore-wotlk` (the read-only mirror of CC's live AC version) and fetch the live label sets of the CC and AC repos.
- **Web search/fetch** — Wowhead (TBC + current), Wowpedia (with pre-Cata history), Wayback Machine, YouTube (with caveats — see `references/source-quality.md`).
- **AzerothCore MCP** — world DB queries (`creature_template`, `quest_template`, `gameobject_template`, `smart_scripts`, `conditions`, `spell_dbc`, etc.) and AC source grep. **Best-effort:** when available it is the highest-value move; when absent or down, still produce an answer. If a DB/source check you could not run was the *deciding* factor, land on an `Unclear` verb rather than guessing.

## Process

Gate-first, then a cost-ordered validity hunt. Stop as soon as you can recommend confidently. The costly mistake is **misrouting** (sending a website/mod/client-side/misconfig bug to AC), so the routing gate runs early and can pre-empt the validity hunt.

### Step 1 — Parse & classify (no tool calls)

New reports follow a known template. Parse its fields rather than treating the body as free text (old/templateless reports: fall back to free-text extraction):

- **`bug_report.yml` (game):** `Current Behaviour`, `Expected Behaviour`, `Official Sources`, `Steps to reproduce`, `AC rev. hash/commit`, `Extra Notes`, `Customizations`.
- **`web_bug_report.yml` (website):** `Current/Expected Behaviour`, `Steps to Reproduce`, `Browser`, `Device`, `Operating System`, `URL`.

Extract and flag:
- **Entities**: quest/item/NPC/spell IDs and names, GUIDs, zones, coordinates.
- **Symptom**: what happens vs. what was expected.
- **Reporter's `AC rev. hash`**: what the *reporter* was running (the report's own field — used to understand their version, **not** as CC's current version; see Step 3).
- **Completeness**: are the required fields actually filled with usable content? Empty/low-quality required fields point toward `Unclear — request more info from reporter`.
- **Routing/disqualifier flags**: which template was used (web template → strong Website signal), CC-mod mentions (`references/cc-mods.md`), website mentions, client-side red flags (`references/client-side-red-flags.md`), misconfiguration hints, prior triage attempts in comments.
- **Multiple distinct bugs**: if the report bundles several unrelated bugs, note each — the recommendation will be to split (see Dossier template).

### Step 2 — Routing gate (cheap, runs early; can short-circuit)

If Step 1 raised a routing/disqualifier flag, resolve it before (or alongside) the validity hunt:

- **Website** — arrival via `web_bug_report.yml`, or a website-only symptom (account portal, donations, forum, wiki, a chromiecraft.com URL). Strong but not conclusive: sanity-check there is no in-game symptom. → `Valid — Website`.
- **CC mod** — a recognition phrase or mod-only symptom (`references/cc-mods.md`). Decide between a real mod bug (`Valid — port to <mod> repo`) and a CC misconfiguration (`Invalid — module misconfiguration`).
- **Client-side** — visual/display/tooltip/model/UI symptom (`references/client-side-red-flags.md`). Usually `Unclear — request more info from reporter` first (locale/mods), then `Invalid — client-side` once confirmed. Do **not** assume client-side just because a symptom is visual — many real server bugs manifest visually.
- **Out of scope** — a feature request, question, or balance complaint rather than a bug → `Invalid — out of scope (not a bug report)`.

When a gate resolves the report cleanly, write the dossier and stop. When a flag is ambiguous, do not short-circuit on it — keep investigating and surface the ambiguity in "What I'm uncertain about."

### Step 3 — Validity investigation (cost-ordered, parallel where possible, stop on decisive evidence)

Run cheapest-decisive-first; parallelize independent checks:

1. **CC duplicate search** — `chromiecraft/chromiecraft` issues (open + recently closed) for the extracted entities. Same entities **and** same symptom → `Invalid — duplicate of <link>`.
2. **AC search** — `azerothcore/azerothcore-wotlk` issues *and* recently merged PRs. Record whether matching AC issues are `Confirmed` or unconfirmed.
   - **Already fixed?** Determine CC's *current* deployed version from **HEAD of `chromiecraft/azerothcore-wotlk`** (the authoritative read-only mirror — not the report's hash, not the template default). A fix counts as `Invalid — already fixed` only if the fixing PR's merge commit is an **ancestor of** that HEAD (i.e. actually live on CC). A merge *date* earlier than something is **not** sufficient.
3. **Other emulators** — same bug is often filed already, sometimes with a fix.
   - `TrinityCore/TrinityCore` — **`3.3.5` branch only**; treat other branches as weak evidence.
   - `cmangos/*`, `vmangos/*`.
4. **Web sources** (Wrath-era only — `references/source-quality.md`) — Wowhead ([TBC](http://tbc.wowhead.com/) / [current](https://www.wowhead.com/) filtered to Wrath-era comments), Wowpedia (article History, last revision before Oct 12, 2010). Also evaluate the reporter's own `Official Sources` field here — do not take it at face value.
5. **AC DB & source** (via MCP, if available) — quote relevant rows / `file:line` in the dossier; highest-value move when available. Deep web (YouTube Wrath-era retail footage, Wayback, MMO-Champion archives) only if still inconclusive — most issues never need it.

### Step 4 — Decide

Scan `CASES.md` for the case your evidence matches; it gives the exact verb, confidence calibration, and what to write. If no case matches cleanly, the default is one of the `Unclear` verbs — see `CASES.md` and `references/cc-tracker-purpose.md` for picking between them. The CC tracker is a service desk: bias toward making a deliberate call over leaving the report in limbo.

## Confidence

- `High` — multiple independent pieces of evidence converge.
- `Medium` — one strong piece, or several weak ones pointing the same way.
- `Low` — inconclusive. Verb must be one of the `Unclear` options.

## Dossier template

Always produce this shape:

```markdown
> 🤖 **Automated triage assistant.** This is a non-binding first-aid analysis to help a
> contributor triage faster — not a decision. A human reviews and makes the final call.

## CC#<NUMBER> — <short symptom>

**Recommendation:** <verb from CASES.md, verbatim>
**Confidence:** <High | Medium | Low>

<one or two sentences citing the single best piece of evidence, with inline links>

<details>
<summary>Evidence</summary>

### Is this valid?
- **Duplicates on CC:** <links + one-line relevance, or "none found">
- **Already on AC:** <link + status (Confirmed/unconfirmed/closed), or "none found">
- **Recently merged AC PRs:** <link + whether it's an ancestor of CC's deployed HEAD, or "none relevant">
- **Other emulators (TC 3.3.5 / CMaNGOS / vMaNGOS):** <links + relevance, or "none found">
- **DB / source findings:** <quoted rows or file:line, or "MCP unavailable" / "not investigated">
- **Web sources (Wrath-era only):** <paraphrase + link, or "no Wrath-era sources found">
- **Reporter's cited sources:** <assessment against source-quality.md, or "none / not usable">

### Where does it go?
- **CC-mod indicators:** <none | mod name + recognition phrase>
- **Website indicators:** <none | reason (e.g. filed via web template)>
- **Client-side indicators:** <none | red flag + suggested question for reporter>
- **Suggested CC-issue label:** <label that actually exists on the CC repo, or "none">
- **Suggested AC categorization (when ported):** <existing AC bracket/Generic + category label, or "n/a">

### What I checked
- <brief list of tool calls / searches made — the audit trail>

### What I'm uncertain about
- <unresolved questions, missing data, sources you couldn't reach, suspected-but-unverified duplicates>

</details>
```

Adaptations:
- **Suggested labels** must be real. Fetch the current label sets from the CC and AC repos and only suggest labels that exist there. Never invent a label.
- **DRAFT AC issue** — only for `High`-confidence `Valid — port to AC`, add a `<details><summary>DRAFT AC issue — review before filing</summary>` block with a ready-to-paste AC issue (clear repro, entities, Wrath-era sources, suggested bracket). Mark it clearly as a draft; the human reviews and submits.
- **Multiple bugs** — if the report bundles several distinct bugs, set the top-line recommendation to splitting them into separate reports, and under "Is this valid?" enumerate each sub-bug with a one-line mini-verdict so none is triaged silently.

## File map

- **`CASES.md`** — operational lookup and **single source of truth for the verb strings**, one section per recommendation verb. Consult on every triage.
- **`references/cc-mods.md`** — CC mod recognition phrases and routing. Consult during the routing gate if mod-flavor language is present.
- **`references/client-side-red-flags.md`** — patterns that smell client-side. Consult when the symptom is visual or display-related.
- **`references/source-quality.md`** — source weighting, Wrath cutoff, contamination warnings. Consult when weighing web sources and the reporter's cited sources.
- **`references/cc-tracker-purpose.md`** — service-desk framing. Consult when picking between `Unclear` verbs or tempted to punt.

## Iteration and curation

This skill is curated by humans, **not self-modifying** — it never edits itself while triaging. Improvement happens out-of-band: when a contributor spots a bad dossier on a GitHub issue, they open a fresh local session, hand it the issue link, and direct it to apply the correction to the relevant skill document.

Norms for those correction sessions:
- **Edit the relevant existing document** — `SKILL.md`, `CASES.md`, or a `references/*.md`. Keep the modular structure; do not add meta-docs.
- **Add to existing sections rather than creating new ones.**
- **Examples beat abstractions.** Record real misclassifications as worked examples in `CASES.md` under the relevant case.
- **Keep `SKILL.md` lean** — detailed patterns belong in `CASES.md` or the references.
