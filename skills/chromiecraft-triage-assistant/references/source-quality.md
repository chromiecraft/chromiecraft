# Source Quality Heuristics

AzerothCore targets WoW patch **3.3.5a** (final Wrath patch, June 2010). Wrath ran **Oct 14, 2008 – Oct 12, 2010**. Sources outside this window are not evidence of correct behavior unless they explicitly discuss Wrath.

## Weighting

Roughly, from strongest to weakest:

1. **Sniff data** — intercepted retail packets. Authoritative for client-visible values (speeds, flags, spawn data) but patchy. See [AC SpeedChecker](https://azerothcore-speedchecker.web.app/).
2. **Wowpedia pre-Cata revisions** — use the article History feature; pick the last revision before **Oct 12, 2010**. Often aggregates patch notes — very useful for class/talent/ability changes.
3. **TBC Wowhead** — <http://tbc.wowhead.com/> — for content that existed in TBC.
4. **Current Wowhead, Wrath-era comments only** — filter comments by date. The data itself can be contaminated by private-server players (especially drop rates).
5. **TrinityCore 3.3.5 branch issues/PRs** — different codebase but same emulation target. Solutions often portable. **Only the `3.3.5` branch** — master/cata/mop branches are not evidence.
6. **CMaNGOS issues** — smaller corpus, similar value to TC.
7. **YouTube — Wrath-era retail footage** — rare but golden when found. Verify the uploader was on retail, not a private server.
8. **MMO-Champion forum archives** — predates Wrath; sometimes has firsthand info.
9. **WoW official forums** — usually flame and contradiction; weak.
10. **WowGaming / wotlkdb.com** — third-party DB snapshots; useful for cross-reference, not primary.

## Red flags to discount

- **Post-Cataclysm patch notes** — the Cata pre-patch (4.0.1, Oct 12 2010) changed talent trees, stats, and many abilities. Anything dated after that is wrong for our target.
- **Classic / TBC balance** — Vanilla and TBC behaviors were changed in Wrath. "It worked this way in Vanilla" is not evidence.
- **Bue (YouTube)** — frequently top result for quest searches; plays on a private server, not retail. **Do not cite as evidence.**
- **Other private-server YouTube** — if you can't verify the uploader was on retail in 2009–2010, do not cite.
- **Wowhead drop rates submitted post-2010** — likely contaminated by private-server reports. Cite the existence of the item/drop, not the rate.
- **Reddit / forum claims of "I've played since vanilla"** — anecdotal; treat with skepticism per the triaging guide.

## When sources conflict

The triaging guide is explicit: *"Verified and validated original 3.3.5 sources take precedence where available. Where such sources are absent or conflicting, we exercise our own discretion and judgement."*

When you see conflicts:
- Note the conflict in the dossier rather than picking a side.
- If one source is sniff data and the other is a Wowhead comment, weight the sniff.
- If one source is Wrath-era and the other is post-Cata, the Wrath-era source wins.
- If you genuinely cannot resolve it, that's a `Needs human investigation` signal — lower the confidence.

## When you find nothing

The guide: *"if you can't find any sources, at least say so instead of saying nothing."* Surface this in "What I'm uncertain about." Do not paper over silence with weak sources.

## Curator notes

Add new contaminating sources, new useful sources, and new conflict patterns here as encountered.
