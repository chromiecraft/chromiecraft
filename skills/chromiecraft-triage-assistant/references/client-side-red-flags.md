# Client-Side Red Flags

The WoW 3.3.5a client is far from perfect. Many reports that look like server bugs are actually client display issues, locale issues, or user-installed graphics mods. These cannot be fixed by AzerothCore. This file lists the patterns and the questions to ask.

## Red-flag patterns

### Display vs. reality mismatch
Symptoms where the player *sees* something wrong but the *underlying behavior* is correct.

- "Item sells for 0 copper" — known client bug for low-level items. Check whether the player's actual money changes by the correct amount. The display lies, the transaction is fine.
- "Tooltip shows X but I got Y." If the gameplay outcome is correct, the tooltip is the bug, and it's client-side.
- "Stat shows wrong on character sheet." Compare against actual combat behavior. The sheet is frequently wrong.

### Locale-specific issues
The enGB client is more prone to display issues than enUS. If the report involves text rendering, quest text formatting, tooltip text, or NPC dialogue display, **ask which client locale they're using**. If enGB and the issue is text-shaped, it may not be fixable on the server side.

### Graphics / model / texture issues
Symptoms:
- "This NPC looks weird / has the wrong model / is invisible."
- "Spell effect is missing or wrong-colored."
- "Armor texture is purple/missing/stretched."
- "Mount looks like a different mount."

These are *almost always* either client mods (model swaps, texture replacements) or local file corruption. **Ask the reporter whether they run any client-side mods, model swappers, or HD texture packs.** Most players will not volunteer this information even though they have it installed.

### Pure UI bugs
- Map markers in wrong place
- Quest objective counter not updating visually (but quest completes correctly)
- Buff/debuff icons missing or duplicated
- Action bar slot showing wrong icon

If toggling the UI (`/console reloadui`), changing zones, or relogging fixes it temporarily, it's client-side.

## What to recommend

For clear client-side issues (verbs quoted verbatim from `CASES.md`):

- **Pure display bug, no gameplay effect, locale/mods not yet asked about** → `Unclear — request more info from reporter` and list the specific questions (locale? client mods? reproduces after `/console reloadui`?).
- **Confirmed client-side after reporter responds in comments** → `Invalid — client-side`.
- **Reporter has explicitly mentioned client mods causing it** → `Invalid — client-side` with high confidence.

## What NOT to do

- Do not classify as client-side just because the symptom is visual. Many real server bugs manifest visually (e.g. an NPC actually has the wrong faction in DB → it really is the wrong color on minimap).
- Do not assume client-side without checking the DB / source first if the tools are available. A 30-second DB lookup can confirm whether the visual matches the data.
- Do not short-circuit to `Invalid — client-side` on first glance — the first move is `Unclear — request more info from reporter`, and only after the reporter confirms locale/mods does it become a clean `Invalid — client-side`.

## Curator notes

When a new client-side pattern recurs, add it under "Red-flag patterns" above with a short description and the disambiguating question.
