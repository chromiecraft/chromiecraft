# CC Mods — Recognition and Routing

ChromieCraft runs a number of mods on top of vanilla AzerothCore. Bugs caused by these mods are **still valid CC issues** — the CC report stays open. The additional action is to link/file them on the relevant mod's repo so the right maintainers see them. They do **not** belong on the AC tracker.

Source of truth for the live mod list: <https://github.com/chromiecraft/chromiecraft/blob/main/.github/CC_SERVER_INFO.md>. When in doubt, check it.

## How to use this file

1. During Tier 0, scan the report body and comments for any phrase in the "Recognition phrases" column.
2. If a match is found, raise a CC-mod indicator and follow the routing in the same row.
3. If the report's symptom *only makes sense* in a mod's context (e.g. a cross-faction interaction), raise the indicator even without an explicit phrase match.
4. The recommendation in the dossier is `Link to mod repo and keep CC issue open` — the CC issue is valid, the mod repo is where the fix happens.

## Known mods

| Mod | Recognition phrases | Repo / Routing target |
|---|---|---|
| **CFBG** (Cross-Faction Battlegrounds) | "CFBG", "cross-faction BG", "Horde and Alliance in same BG", "mixed-faction battleground" | `azerothcore/mod-cfbg` |
| **Cross-Faction Dungeons** | "cross-faction dungeon", "mixed-faction group", "Horde and Alliance in dungeon" | `azerothcore/mod-cfbg` (typically) — verify in CC_SERVER_INFO.md |
| **Duel Reset** | "duel reset", "HP reset after duel", "duel cooldowns reset" | `azerothcore/mod-duel-reset` |
| **Low-Level Arenas** | "low level arena", "arena at level X (<70)", "skirmish at low level" | Check CC_SERVER_INFO.md for current low-level-arena mod |
| **Solo LFG** | "solo LFG", "queueing dungeon alone", "dungeon finder solo" | `azerothcore/mod-solo-lfg` |
| **Progression System** | level-bracket mismatches — "vendor sells level 60 gear in level 40 bracket", "quest reward above current bracket cap", "mob/item from wrong phase" | `azerothcore/progression-system` |
| **Auto-Balance** (if enabled on CC) | "dungeon scales weird", "boss too easy/hard for group size", "auto balance" | `azerothcore/mod-autobalance` |

## Progression-system: the big one

This is the most frequent CC-mod miscategorization. CC plays through expansions in brackets. If a report's symptom is *"X is available when it shouldn't be at this level/phase"* or *"this content shouldn't be unlocked yet"*, it's almost certainly a progression-system issue, **not** an AC bug.

Examples:
- "I can buy level 70 enchanting materials in Outland but we're still in vanilla content."
- "This raid is open and shouldn't be."
- "Honor system seems active but we're still pre-PvP-patch."

Route these by linking to `azerothcore/progression-system` while keeping the CC issue open.

## When in doubt

If a report has *some* mod-flavor but you're not sure, **do not short-circuit on it**. Flag the indicator, keep investigating, and surface the ambiguity in the dossier's "What I'm uncertain about" section. Better to escalate than misroute.

## Curator notes

Add new mods and recognition patterns here as you encounter them. Prefer adding rows to the table over creating new sections.
