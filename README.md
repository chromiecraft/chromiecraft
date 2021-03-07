# ChromieCraft.com Bug Tracker

## FOR PLAYERS: How to report bugs

1. Check the [bug list](https://github.com/chromiecraft/chromiecraft/issues) to see if the bug has already been reported. If yes, open the matching report and add your comment with "Confirmed". If possible, please add your core revision hash and a note telling us if this is your own local server or an online AC server).

2. If the bug has not been reported yet, please [create a new ticket](https://github.com/chromiecraft/chromiecraft/issues/new). Please fill in all of the requested details.

- [**ChromieCraft issue tickets**](https://github.com/chromiecraft/chromiecraft/issues) : The complete list of currently reported issues (bugs).
- [**Create a new issue ticket**](https://github.com/chromiecraft/chromiecraft/issues/new) : Open a new ticket page to fill in the required information.

## FOR CONTRIBUTORS: How to triage/report bugs

### Triage

It is the duty of the [AzerothCore](https://www.azerothcore.org/) contributors, or anyone in general who wants to contribute to the ChromieCraft project, to:

1. Verify the issues reported by the users (check validity, duplicates, etc.). All issues waiting to be triaged are marked as [[needs triage]](https://github.com/chromiecraft/chromiecraft/issues?q=is%3Aissue+is%3Aopen+label%3A%22needs+triage%22).

2. If the issue is not valid (missing information, not a bug, etc.), it should be closed (or you can ask the user for further clarification).

3. If the issue is valid and the bug can be reproduced on a clean AC server (at a recent version), open a report in the [main AC repo issue tracker](https://github.com/azerothcore/azerothcore-wotlk/issues). You can literally copy-paste the issue from ChromieCraft to AzerothCore, as the template already contains all information needed for AC. In addition, add the link to the original issue reported to ChromieCraft ("Originally reported LINK-TO-CHROMIECRAFT-ISSUE"). GitHub will automatically link the two reports.

4. Add the correct level bracket tag to the AC issue tracker ticket report, for example [[1-19]](https://github.com/azerothcore/azerothcore-wotlk/labels/1-19).

5. In the issue ticket reported in the ChromieCraft repo, mark them as LINKED by adding the proper label. Once the linked issue on AC has been closed, we can add the FIX-READY label to the ChromieCraft report.

6. Admins will close all issues labeled FIX-READY, as soon as ChromieCraft gets updated with the latest AC build.

### Report

If you find a bug yourself, you can report it directly to the AC issue tracker. You can copy-paste [this template](https://raw.githubusercontent.com/chromiecraft/chromiecraft/main/issue_template.md) and simply fill in the bug description.

### Links

[**Project by Brackets**](https://github.com/azerothcore/azerothcore-wotlk/projects) : The projects, subdivided by brackets. Allows you to check the technical progress status.

[**AzerothCore issue tracker**](https://github.com/azerothcore/azerothcore-wotlk/issues) : This is our official gaming core issue tracker.
