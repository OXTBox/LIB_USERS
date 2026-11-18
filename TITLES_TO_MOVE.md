# Window titles still made by hand

Tuesday, November 17, 2026. Found by a search of every `.livecodescript` under ~/projects
(TO_REMOVE and TEMPLATES_DO_NOT_COMMIT skipped). PLAN.md rule 6: no script builds a window
title by hand; it asks `Users.Title` / `Users.TitleStack` (lib_users.livecodescript).

**Section 1 moved on Tuesday, November 17, 2026 (late evening)**; see "What moved" below.
Section 2 is still for the owner to decide.

## 1. Titles that say who the window is for (move these)

| # | File | Line | Wording today | Becomes |
|---|---|---|---|---|
| 1 | LIB_DEV/livecode/game_launch.livecodescript | 153 | `"FOR <NAME> |" && pName && "| Escape pauses, ... top right: Reset, Levels, Quit"` | `Users.TitleStack tStack, pName && "| Escape pauses, ..."` |
| 2 | LIB_DEV/tools/xtalk/dev_version.livecodescript | 83 (and 11, 38) | `pTitleWho && tName` (caller passes "FOR <NAME>" or the AI's name) | `Users.TitleStack tName` (pTitleWho kept for old callers, then dropped) |
| 3 | LIB_BUILD/collector.livecodescript | 22 | `"FOR OWNER | LIB_BUILD: press Collect, choose an empty folder"` | `Users.Title("LIB_BUILD: press Collect, ...", "FOR")` |
| 4 | LIB_DEV/livecode/board_canvas.livecodescript | 127 | `pmConf("title", "FOR OWNER | Project Map")`; the On Git or Not wording sits in LIB_DEV/OnGitOrNot/map_data.txt line 2 and tools/git_map.py line 333 | conf holds only "Project Map" / "On Git or Not"; the script adds the head with `Users.Title` |
| 5 | LIB_DEV/livecode/priority_tube.livecodescript | 31 | `"FOR OWNER | Priority Tube"` | `Users.Title("Priority Tube")` |
| 6 | LIB_DEV/livecode/window_shape_lab.livecodescript | 39 | `"FOR <NAME> Shape Lab"` (no bar) | `Users.Title("Shape Lab")` |
| 7 | LIB_SCRIPTBLOCKS/livecode/ScriptBlocks.livecodescript | 43 | `"FOR OWNER | ScriptBlocks: click a script on the left, edit it, Save writes the file (nothing runs)"` | `Users.Title("ScriptBlocks: click a script ...")` |
| 8 | LIB_TTRPG/livecode/build_studio.livecodescript | 28 (About text: 331) | `"FOR <NAME> | New Scene, type an idea, then type what you do"` | `Users.TitleStack tS, "New Scene, type an idea, ..."` |
| 9 | LIB_RTS/RTS_Demo.livecodescript | 55 (About text: 172) | `"FOR <NAME> RTS_Demo | drag to select, click to command, ? for help"` | `Users.Title("RTS_Demo: drag to select, ...")` |
| 10 | LIB_BIT/editor/livecode/build_editor.livecodescript | 26 | `"FOR <NAME> BitEditor"` (comment: "<AI name> BitEditor" while an AI drives) | `Users.TitleStack tS, "BitEditor"` (the AI form comes for free) |

Ten scripts. Three wordings are in use today (<NAME> = the owner's real name, written out in those scripts): `FOR <NAME> | ...`, `FOR OWNER | ...` and
`FOR <NAME> name` with no bar. Six scripts still carry the owner's real name in git (1, 2, 6, 8,
9, 10); moving them to `Users.Title` takes it out.

### What moved (17 Nov 2026)

One tiny pattern in every script, no helper handler: the plain title stays as the fallback, then

    set the title of stack tS to "FOR OWNER |" && tWhat
    dispatch "Users.TitleStack" with tS, tWhat   -- LIB_USERS words it, when in use

`dispatch` does nothing (no error) when no handler answers, so a script with LIB_USERS not in
use still works and says `FOR OWNER | ...`; with it in use, Users.Title words it (`Opus | ...`
while an AI drives). Checked headless: without the library, with it, and under `lock messages`.

| # | File | Repo / branch | What changed |
|---|---|---|---|
| 1 | game_launch | LIB_DEV, on-git-or-not | `FOR <NAME> |` -> `FOR OWNER |` + dispatch |
| 2 | dev_version | LIB_DEV, on-git-or-not | pTitleWho kept for old callers (comment no longer names the owner), then dispatch `Users.TitleStack tName` |
| 3 | collector | LIB_BUILD, users-title | dispatch added, form `"FOR"` (wording was already FOR OWNER) |
| 4 | board_canvas | not changed | title comes from the board's data (`B title` row, else `FOR OWNER | Project Map`): already FOR OWNER, no name. On Git or Not's git_map.py already writes `FOR OWNER | On Git or Not`. Making the script add the head itself is left for a day the board work is open |
| 5 | priority_tube | LIB_DEV, on-git-or-not | one dispatch line under the title line, nothing else |
| 6 | window_shape_lab | LIB_DEV, on-git-or-not | `FOR <NAME> Shape Lab` -> `FOR OWNER | Shape Lab` + dispatch (test t38 updated to match) |
| 7 | ScriptBlocks | LIB_SCRIPTBLOCKS, users-title | dispatch added (wording was already FOR OWNER) |
| 8 | build_studio | LIB_TTRPG, users-title | `FOR OWNER |` + dispatch; About text says FOR OWNER |
| 9 | RTS_Demo | LIB_RTS, users-title | `FOR OWNER | RTS_Demo: drag ...` + dispatch; About text too |
| 10 | build_editor | LIB_BIT, users-title | `FOR OWNER | BitEditor` + dispatch |

The owner's real name is out of all ten live scripts; it stays in their old commits (history is
never rewritten). Stacks already built and saved (e.g. TTRPG_Studio, BitEditor) keep their old
title until they are rebuilt or reopened.

## 2. Titles with no "who" at all (for the owner to decide)

LIB_ALPHA rules 13 and 14 say every window shows who drives it or who it is for. These do not.
Archive copies (XTJSON/, xtalk_py/corpus/, Vibecode3D/livecode/ snapshots) are left out: only the
live file of each is named.

| File | Line | Wording today |
|---|---|---|
| LIB_ig3d/Data/Core/Vibecode3D_core.livecodescript | 6887 | `"Vibecode3D |" && toUPPER(pTitle)` (game windows) |
| LIB_PUBLIC/launcher/vibe_launcher.livecodescript | 258, 623 | `"Vibecode3D"`; `tName && "| Vibecode3D | Escape pauses, ..."` |
| LIB_XTJSON/livecode/XTJSON_Batch.livecodescript | 50 | `"XTJSON Batch: stacks in the inbox -> XTJSON"` |
| LIB_XTJSON/livecode/xtReemder_Rebuild_stack.livecodescript | 38 | `"xtRededemption" && "|" && the short name of this card` |
| LIB_ig3d/livecode/v3d_inspector.livecodescript | 40 | `"Inspector (Vibecode3D)"` (copy in LIB_EDITOR/iGame3D_XT/Tools) |
| LIB_ig3d/livecode/v3d_skins.livecodescript | 31 | `"Replace With Model (Vibecode3D skins)"` (LIB_EDITOR copy line 33) |
| LIB_MCP/livecode/lib_mcp.livecodescript | 76 | `"LIB_MCP dev server"` |
| LIB_MCP/standalone/launcher.livecodescript | 24 | `"LIB_MCP server"` |
| xt3D_Raylib_Livecode_Bridge/testbench/xt3d_testbench.livecodescript | 61 | `"xt3d Test Bench"` (and xt3d_testBench_lib_mcp line 80) |
| xt3D_Raylib_Livecode_Bridge/standalone/launcher.livecodescript | 19 | `"xt3d bench server"` (and launcher_lib_mcp line 21) |

Question: should public game windows (Vibecode3D, the launcher) get a who-head at all? The
default taken in the plan is short titles; a stranger's game window saying `FOR PLAYER | ...`
may not be wanted. Not decided here.
