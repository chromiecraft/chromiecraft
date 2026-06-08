---
name: chromiecraft-triage-assistant
description: "First-aid bug-triage assistant for ChromieCraft (CC), a gaming server built on AzerothCore. Use when asked to triage, investigate, or first-aid a ChromieCraft / github.com/chromiecraft/chromiecraft issue, to judge whether a CC bug report is valid and where it should be ported. Produces a markdown dossier that helps humans to triage bugs."
license: AGPL-3.0
metadata:
  author: Francesco Borzì
  version: "1.0"
---

# ChromieCraft Triage — First Aid

## The job, in two questions

Bug triaging at ChromieCraft is simple:

1. **Is this report valid?** (yes / no / unclear)
2. **If valid, where does it go?** (AzerothCore, a mod repo, or CC Staff — e.g. a website issue or a misconfiguration)

Your job is to answer both, with evidence, in a markdown dossier a contributor can confirm in under two minutes.
You never decide for the human and you never take an action — you **produce a dossier and suggest**.
You do not close, link, label, or file anything.

### Context
ChromieCraft is a WoW WotLK 3.3.5a private server built on [AzerothCore](https://github.com/azerothcore/azerothcore-wotlk).
The [CC tracker](https://github.com/chromiecraft/chromiecraft) is where **players** (not contributors) report bugs.
Contributors triage and port the valid ones. The full triaging guide is [here](https://www.azerothcore.org/wiki/guide-to-triaging).

## What the skill is

This skill is the triage *logic*. An agent (with tools/MCPs — GitHub, web, an AzerothCore DB/source MCP) does the actual work; 
the skill tells that agent how to analyse a CC report and what dossier to produce. 
It runs in one of two modes, chosen by whoever invokes it:

- **Dry-run** — output the dossier as text to the invoker (for local testing and iteration).
- **Production** — post the dossier as a comment on the GitHub issue.

Same dossier either way. Triggering, access control, and cost are deployment concerns, outside this document.

## Hard rules

1. **TL;DR first, with a disclaimer banner.** Every dossier opens with the banner (see template) making clear it is an automated assistant and its recommendation is non-binding pending human review. Then a single-line recommendation, confidence, and best evidence inline. Full evidence goes in a collapsible `<details>` block.
2. **Fixed vocabulary only.** `CASES.md` is the **single source of truth** for the recommendation verbs. Use the verb strings *verbatim* — never paraphrase or invent one. Consistency is the whole point.
3. **Cite only what you fetched this run.** Every issue number, PR, URL, label, and DB row in the dossier must come from an actual tool result in *this* run. Never write an issue number or link from memory or inference. A duplicate you suspect but could not retrieve goes in "What I'm uncertain about" — never as a cited verdict.
4. **Low confidence → an `Unclear` verb.** Never pair a Valid/Invalid verb with Low confidence — it reads as confused.
5. **Always include "What I checked" and "What I'm uncertain about."** Even on short answers. These are the trust mechanism and the audit trail.
6. **Write the dossier in English.** Understand reports in any language, but always output English (the project's and AC's working language).
7. **Wrath cutoff.** AC/CC target patch 3.3.5a (Wrath, Oct 2008 – Oct 2010). Weigh out-of-window sources cautiously — see `references/source-quality.md`.

## Agent tools

These are the tools the agent is **expected to have** and is **expected to use** — they are what turns a guess into an evidenced triage. Inventory them at the start of every run.

**When a tool is missing or errors, do all three:**
1. **Finish the job anyway.** Produce the best dossier the working tools allow — a degraded dossier beats no dossier.
2. **Flag it in the dossier.** Record which tool was unavailable or errored (and the error, if any) under "What I checked", so operators can spot and fix a broken tool. If it limited the verdict, repeat that under "What I'm uncertain about".
3. **Don't guess past it.** If the check you couldn't run would have been *decisive*, lower confidence and prefer an `Unclear` verb over a confident guess.

| Tool | Use it to |
|---|---|
| **GitHub** | Search/read issues & PRs across `chromiecraft/chromiecraft`, `azerothcore/azerothcore-wotlk`, AC module repos, and similar projects (`TrinityCore/TrinityCore`, `cmangos/*`, `vmangos/*`). Read `chromiecraft/azerothcore-wotlk` (the read-only mirror) for the exact AC version live on CC, and read the live CC/AC label sets. |
| **Web search / fetch** | Wowhead (TBC + current), Wowpedia (pre-Cata history), Wayback Machine, YouTube — always weighed per `references/source-quality.md`. |
| **AzerothCore DB (MCP)** | World DB queries (`creature_template`, `quest_template`, `gameobject_template`, `smart_scripts`, `conditions`, `spell_dbc`, …). The highest-value evidence whenever a verdict hinges on server data. |
| **AzerothCore source code** | Read/grep the AC C++ and SQL (`azerothcore/azerothcore-wotlk`) to confirm logic and script behaviour — and as a fallback for DB questions when the MCP is down. |

## Process

Gate-first, then a cost-ordered validity hunt. Stop as soon as you can recommend confidently. The costly mistake is **misrouting** (sending a website/mod/client-side/misconfig bug to AC), so the routing gate runs early and can pre-empt the validity hunt.

### Step 1 — Parse & classify (no tool calls)

New reports follow a known template. Parse its fields rather than treating the body as free text (old/templateless reports: fall back to free-text extraction):

- **`bug_report.yml` (game):** `Current Behaviour`, `Expected Behaviour`, `Official Sources`, `Steps to reproduce`, `AC rev. hash/commit`, `Extra Notes`, `Customizations`.
- **`web_bug_report.yml` (website):** `Current/Expected Behaviour`, `Steps to Reproduce`, `Browser`, `Device`, `Operating System`, `URL`.

Extract and flag:
- **Entities**: quest/item/NPC/spell IDs and names, GUIDs, zones, coordinates, etc
- **Symptom**: what happens vs. what was expected.
- **Reporter's `AC rev. hash`**: this field is auto-filled by the issue template (the player does not edit it), so it indicates the AC version CC was running roughly when the report was filed. Useful context — but CC updates ~weekly, so for the "already fixed" check use CC's *current* deployed version, which may be newer (see Step 3), not the value frozen in the report.
- **Completeness**: are the required fields actually filled with usable content? Empty/low-quality required fields point toward `Unclear — request more info from reporter`.
- **Routing/disqualifier flags**: which template was used (web template → strong Website signal), CC-mod mentions (`references/cc-mods.md`), website mentions, client-side red flags (`references/client-side-red-flags.md`), misconfiguration hints, prior triage attempts in comments.
- **Multiple distinct bugs**: if the report bundles several unrelated bugs, note each — the recommendation will be to split (see Dossier template).

### Step 2 — Routing gate (cheap, runs early; can short-circuit)

If Step 1 raised a routing/disqualifier flag, resolve it before (or alongside) the validity hunt:

- **Website** — arrival via `web_bug_report.yml`, or a website-only symptom (account portal, donations, forum, wiki, a chromiecraft.com URL). Strong but not conclusive: sanity-check there is no in-game symptom. → `Valid — report to CC Staff` (website case).
- **CC mod** — a recognition phrase or mod-only symptom (`references/cc-mods.md`). Decide between a real mod bug (`Valid — port to <mod> repo`) and a CC misconfiguration (`Valid — report to CC Staff`) — both are valid reports, just different destinations.
- **Client-side** — visual/display/tooltip/model/UI symptom (`references/client-side-red-flags.md`). Usually `Unclear — request more info from reporter` first (locale/mods), then `Invalid — client-side` once confirmed. Do **not** assume client-side just because a symptom is visual — many real server bugs manifest visually.
- **Out of scope** — a feature request, question, or balance complaint rather than a bug → `Invalid — out of scope (not a bug report)`.

When a gate resolves the report cleanly, write the dossier and stop. When a flag is ambiguous, do not short-circuit on it — keep investigating and surface the ambiguity in "What I'm uncertain about."

### Step 3 — Validity investigation (cost-ordered, parallel where possible, stop on decisive evidence)

Run cheapest-decisive-first; parallelize independent checks:

1. **CC duplicate search** — `chromiecraft/chromiecraft` issues (open + recently closed) for the extracted entities. Same entities **and** same symptom → `Invalid — duplicate of <link>`.
2. **AC search** — `azerothcore/azerothcore-wotlk` issues *and* recently merged PRs. Record whether matching AC issues are `Confirmed` or unconfirmed.
   - **Already fixed?** A fix only counts if it's actually live on CC: the fixing PR's merge commit must be an **ancestor of** HEAD of `chromiecraft/azerothcore-wotlk` (not the report's hash, not a merge *date*). Full test in `CASES.md` → `Invalid — already fixed`.
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

**Validity clear, routing uncertain?** If the bug is clearly real but the destination is not (e.g. AC vs a mod), still pick the most-likely destination verb, set confidence to reflect the *routing* doubt (Medium/Low), and explain the "validity clear, routing uncertain" split in "What I'm uncertain about." Reserve `Unclear — flag for second opinion / staff review` for when *validity itself* is undecided — not merely the routing.

## Dossier template

Always produce this shape:

```markdown
> 🤖 **Automated Bug-Triage Assistant (AI-generated).** First-aid notes to help a contributor triage faster — a human reviews and decides.

## CC#<NUMBER> — <short symptom>

**Recommendation:** <verb from CASES.md, verbatim>
**Confidence:** <High | Medium | Low>

<one or two sentences citing the single best piece of evidence, with inline links>

<details>
<summary>Evidence</summary>

*Include only the rows that carry real signal for this report — omit the rest rather than padding with "none found". "What I checked" and "What I'm uncertain about" are always included.*

### Is this valid?
- **Duplicates on CC:** <links + one-line relevance>
- **Already on AC:** <link + status (Confirmed / unconfirmed / closed)>
- **Recently merged AC PRs:** <link + whether it's an ancestor of CC's deployed HEAD>
- **Similar projects:** <links + relevance (TC `3.3.5` strongest)>
- **DB / source findings:** <quoted rows or file:line>
- **Web sources (Wrath-era only):** <paraphrase + link>
- **Reporter's cited sources:** <assessment against source-quality.md>

### Where does it go?
- **CC-mod indicators:** <mod name + recognition phrase>
- **Website indicators:** <reason (e.g. filed via web template)>
- **Client-side indicators:** <red flag + suggested question for reporter>
- **Suggested CC-issue label:** <a label that exists on the CC repo>
- **Suggested AC categorization (when ported):** <existing AC bracket/Generic + category label>

### What I checked
- <brief list of tool calls / searches made — the audit trail>

### What I'm uncertain about
- <unresolved questions, missing data, sources you couldn't reach, suspected-but-unverified duplicates>

</details>
```

Adaptations:
- **Suggested labels** must be real. Fetch the current label sets from for the CC repository ( https://github.com/chromiecraft/chromiecraft/labels ) and for the AC repository ( https://github.com/azerothcore/azerothcore-wotlk/labels ) and only suggest labels that exist there. Never invent a label.
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
