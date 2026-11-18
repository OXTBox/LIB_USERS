# LIB_USERS: the plan

Monday, November 16, 2026. Draft 1, by Fable 5.2, for the owner to correct. TODO A-43 (and the
answer to O-9, and the part of A-30 that words window titles). A plan only: no code yet.

## 1. What it is for

One place that knows **who is at the controls** of any window, tool or game, so that three
things stop being done by hand:

| Use | Today | With LIB_USERS |
|---|---|---|
| **Titles** | every script writes its own (`"FOR BILL |" && ...`, `"FOR OWNER | ..."`), two different wordings in the rules | `Users.Title` words them all, one way |
| **Logs** | lines carry no name; nobody can tell an AI's run from the owner's | `Users.Stamp` puts time and name on every line |
| **Permissions** | none: any driver can do anything | `Users.May("save")`: a short list of words per user |

Permissions here are a **seat belt, not a lock**. They stop honest tools and agents doing the
wrong thing by accident (Spark saving over a stack, an agent reading a private folder). Anyone
with the files can go round them; real secrets stay out of the folder altogether.

## 2. What it stands on

- xTalk only, no engine, no windows. One script library, `livecode/lib_users.livecodescript`.
- LIB_DATA for the per-machine part (the kind `Users` already exists: `Documents/Data/Users/`).
- What is already in this folder and stays as it is: `personas/` (twelve made-up players for
  install tests), `BILL/` (the owner's private notes, git-ignored, read by nobody but the owner),
  `Vibe/About_vibe.txt` (the owner's; taken here as his sketch of "a folder a user, with an About
  file", see question 5).

## 3. The files

### 3.1 The roster: `users.tsv` (in git, public, no real names)

Roles, not people. One line a role, tab-separated, `#` lines are comments.

```
# tag	kind	title	may	what for
OWNER	person	FOR	all	decisions, taste, playing tests
PLAYER	person	FOR	play,notes	anyone who installed a game
FABLE	ai	drive	run,edit,save,write,launch	architecture and hard design
OPUS	ai	drive	run,edit,save,write,launch	the daily engineer
SONNET	ai	drive	run,edit,save,write	mechanical, well-specified jobs
HAIKU	ai	drive	run,edit,write	mechanical, well-specified jobs
SPARK	local-ai	drive	draft	bulk first drafts, always reviewed
AGENT	ai	drive	run	any other tool or model on the MCP line
```

| Column | Meaning |
|---|---|
| `tag` | capitals, no spaces: what shows in titles and logs |
| `kind` | `person`, `ai`, `local-ai`, `persona` |
| `title` | `FOR` = "this window is for you to try"; `drive` = "I am driving this window" |
| `may` | the permission words (3.3), or `all` |

Personas are not copied in: `personas/personas.tsv` is read as more roster lines of kind
`persona`, with `may` = `play,notes`.

### 3.2 This machine: the Data folder (never in git)

```
Documents/Data/Users/current.txt        who sits here:   OWNER <tab> BILL
Documents/Data/Users/BILL/              that person's own notes (game saves do NOT go here: Documents/My Games/<Game>, section 9 #6)
```

The role `OWNER` is in git; the name `BILL` is only on the owner's machine. On a stranger's PC
the file is missing, so the person is `PLAYER` (`FOR PLAYER`; titles never show a name, owner 18 Nov).
This is how the public copy never carries the owner's name, and how Lee's family PC (two
accounts) gets two names for free.

### 3.3 The permission words

| Word | Lets you |
|---|---|
| `play` | start and play games and tools |
| `notes` | write game notes and feedback |
| `run` | run code sent over the MCP line |
| `edit` | change scripts and layouts in memory |
| `save` | save stacks and layouts to disk |
| `write` | write other files (reports, exports) |
| `launch` | start other programs |
| `draft` | write only into the drafts inbox (`LIB_LLMIN`), nowhere else |
| `publish` | put anything on the public page or itch.io: OWNER only |
| `merge` | bring finished work into the main line: OWNER only |
| `private` | read a user's private folder: that user only, never an AI |

## 4. The handlers

```
start using stack ".../LIB_USERS/livecode/lib_users.livecodescript"

put Users.Current() into tWho            -- OWNER           (the person at this PC, by role)
put Users.Driver() into tWho             -- OWNER, or FABLE while an AI drives

Users.Take "FABLE"                       -- an AI takes the controls (first line of any MCP session)
Users.HandTo                             -- gives them back to the person

put Users.Title("Theme_Studio") into tT  -- driving:  "Fable | Theme_Studio"
put Users.Title("Press Space to start, H for help", "FOR") into tT
                                         --           "FOR OWNER | Press Space to start, H for help"
Users.TitleStack "Theme_Studio", "pick a colour, press Save"    -- sets the TITLE, never the name

if not Users.May("save") then exit SaveLayout
put Users.Stamp() && "saved toolbar" & return after tLog   -- 2026-11-16 14:02:11 FABLE saved toolbar
Users.Log "LIB_TOOLBAR", "opened Status Browser"           -- Data/Work/Logs/LIB_TOOLBAR.log, stamped
```

| Handler | Gives or does |
|---|---|
| `Users.Load` | reads `users.tsv`, the personas and `current.txt`; called by itself on first use |
| `Users.List(pKind)` | the tags, one a line |
| `Users.Current()` / `Users.SetCurrent pTag, pName` | the person at this machine; SetCurrent writes `current.txt` |
| `Users.Driver()` | who has the controls now |
| `Users.Take pTag` / `Users.HandTo pTag` | change the driver (in memory only); HandTo with nothing = the current person |
| `Users.Title(pWhat, pForm)` | the title text; pForm empty = by who drives, or `"FOR"` / `"drive"` |
| `Users.TitleStack pStack, pWhat, pForm` | sets that stack's title |
| `Users.May(pWord, pTag)` | true or false; pTag empty = the driver |
| `Users.Stamp()` | `date time TAG` |
| `Users.Log pLib, pLine` | appends a stamped line through LIB_DATA |
| `Users.About(pTag)` | the text of `<tag>/About_<tag>.txt` when there is one |

The driver is kept in one global, `gUsersDriver`, and in the environment name `XT_USER` when
set from outside (a headless run started by an AI sets `XT_USER=OPUS`, so its logs say so).

### The title, decided once

Two wordings were in force: LIB_ALPHA 13 (`127.0.0.1:8769 | CLAUDE | Do you see particle
effects?`) and the owner's later, shorter word (`Fable myStack`: "title space is valuable real
estate"). Taken here:

| Who drives | Title |
|---|---|
| an AI | `Fable | <stack or what is being tested>` (short family name, mixed case) |
| a window for a person to try | `FOR OWNER | <what to do first, which key for more>` (the role, never a name) |
| long form, only when asked (`Users.TitleStyle "address"`) | `127.0.0.1:8769 | Fable | <what>` |

LIB_ALPHA rules 13 and 14 would then say "ask `Users.Title`" (a change for the owner to accept;
this plan does not edit LIB_ALPHA).

## 5. Who owns what (the same words in all four plans)

| Library | Owns | Never does |
|---|---|---|
| **LIB_USERS** | who is at the controls: the roster, the current user, the wording of window titles, the stamp on log lines, the "may I" words | draws nothing, opens no windows |
| **LIB_THEME** (exists) | colours and line weight, as `themes/<name>.txt` | no layout, no widgets |
| **LIB_GUI** | what a window contains: the `.gui` layout file, the widget kinds, the calls `Gui.*`, the message `guiDo`, the native face (real xTalk controls) and the GUI Builder app | no colours of its own (asks LIB_THEME), no content of its own (no launcher list, no user names) |
| **LIB_RAYGUI** | one more face for the same `.gui` file: raygui drawn inside xt3d (iGame3D xRay); the `xt3d_Gui*` calls; how a theme becomes a raygui style | no layout format and no widget kinds of its own |
| **LIB_TOOLBAR** | one app: the floating launcher strip, and its content file `*.toolbar` (what the buttons are, what they open) | no widget code (its window is built by LIB_GUI); it does not decide who may press what (asks LIB_USERS) |

The rules that follow from the table:

1. A window is laid out once, as a `.gui` file, and shown by any face. Nobody ports a window by hand.
2. A new widget kind is added to LIB_GUI first (the format and the native face), then to the other faces.
3. Colour is LIB_THEME's. Who is LIB_USERS's. What is on the launcher is LIB_TOOLBAR's. How it is drawn in raylib is LIB_RAYGUI's.
4. A row of tools inside an app's own window (iGame3D XT's 26 tools) is ordinary `.gui` buttons belonging to that app. LIB_TOOLBAR is only the floating strip that sits outside a window: the projects launcher, or an app's own tools floated the way the 2007 iGame3D main strip was.
5. XTJSON stays the full, lossless record of a stack. A `.gui` file is the small design a person or Spark can write by hand. There is one tool, one way: XTJSON harvest to `.gui`.
6. No script builds a window title by hand: it asks `Users.Title`.

Build order across the four: (1) LIB_USERS core, (2) LIB_GUI stage 1: the format and the native face,
(3) LIB_TOOLBAR, the first real customer, (4) LIB_RAYGUI: one button proven in the bench, then the
player, (5) the GUI Builder app, (6) the vector face for iGame3D XT.

Where LIB_USERS meets the others: LIB_TOOLBAR shows `Users.Driver()` at its left end and hides
buttons the driver may not press (`Users.May("launch")`); LIB_GUI's Builder asks
`Users.May("save")` before writing a layout and titles its windows with `Users.TitleStack`;
LIB_RAYGUI needs nothing from it. LIB_MCP's server calls `Users.Take` when a client connects and
`Users.HandTo` when it leaves. LIB_DEV's `dev_version` and `game_launch` and LIB_BUILD's
collector swap their hand-written titles for `Users.Title` (that is A-30).

## 6. What is built first

| Step | What | Done when |
|---|---|---|
| 1 | `users.tsv`, `Users.Load / List / Current / Driver / Take / HandTo` | headless test passes |
| 2 | `Users.Title`, `Users.TitleStack`; swap the three hand-written titles (LIB_DEV, LIB_BUILD) | the owner sees `FOR OWNER | ...` on the Game Player and `Opus | ...` while Opus drives |
| 3 | `Users.Stamp`, `Users.Log` | a log line with a name in `Data/Work/Logs` |
| 4 | `Users.May`; LIB_MCP calls Take / HandTo; the toolbar asks it | Spark's tag cannot save a stack in the test |
| 5 | `Users.SetCurrent` for a persona (install tests and games share one "who") | escape sim reads the same roster |

Steps 1 to 3 are about a day for Opus. Nothing here needs Fable again.

## 7. How it is tested headless

`OXT-BEYOND/tests/oxt_headless.py` with a body `tests/t_users.txt`, on a COPY of the folder and
a temporary Data folder (`Data.UseRoot`), so the real `current.txt` and `BILL/` are never touched:

- the roster loads: 8 roles and 12 personas; a broken line is reported, not swallowed
- no `current.txt`: the current user is `PLAYER` with the PC's user name
- `Users.SetCurrent "OWNER","BILL"` then `Users.Title("x","FOR")` is `FOR OWNER | x` (the name is never shown)
- `Users.Take "FABLE"`: `Users.Title("x")` is `Fable | x`; `Users.May("publish")` is false
- `Users.Take "SPARK"`: `Users.May("save")` false, `Users.May("draft")` true
- `Users.May("private")` is false for every `ai`, `local-ai` and `persona`
- `Users.TitleStack` changes the title of a test stack and leaves its name alone
- `Users.Stamp()` ends with the driver's tag

## 8. Options rejected

| Option | Why not |
|---|---|
| Real names in the roster in git | the folder goes public; the owner's name and notes must not |
| A login with passwords | nothing here is secret enough, and a forgotten password locks the owner out of his own tools |
| One global everyone sets by hand (`gUser`) | that is today's habit with titles: three wordings in three scripts |
| Permissions per file or per folder | too fine to keep right; eleven words cover what has gone wrong so far |
| A Python twin of the library | Python waits for the pythonizing day; `users.tsv` is plain text any tool can read already |
| Putting personas and workers in one file | personas are test data with their own columns and their own reader (`escape_sim.py`) |
| Keeping the MCP address in every title | the owner asked for short titles; the long form stays as an option |

## 9. Questions only the owner can answer (answered 18 Nov 2026)

| # | Question | Default taken | Owner's answer (18 Nov) |
|---|---|---|---|
| 1 | The users list and short tags (O-9) | OWNER, PLAYER, FABLE, OPUS, SONNET, HAIKU, SPARK, AGENT, plus the twelve personas | Kept. Personas have all lower case names, so they are never taken for an LLM (`Users.Tag`, done) |
| 2 | Your name in titles: `FOR BILL` or `FOR OWNER`? | `FOR BILL` on your machine | **`FOR OWNER`**: safer for screenshots, protects other people's privacy. Titles say the role, never a name (done: a stranger sees `FOR PLAYER`) |
| 3 | Title wording: short or long form with the address? | short; long on request | Short by default, long on request; the long form will be needed for multiplayer games and remote devices |
| 4 | May an AI save stacks without asking? | yes for Fable, Opus, Sonnet; never Spark; only you publish or merge | Yes, as taken: Fable, Opus, Sonnet. **Haiku does not save stacks for now** (owner, 18 Nov). Keep Spark working exactly as it works now |
| 5 | `Vibe/About_vibe.txt`: is `Vibe` a user? | left untouched | No. "VIBE" means the V: drive, the C: simulation; `V:/Users/Public` is the generic test-install account |
| 6 | Game saves and settings under `Data/Users/<name>/`? | not yet | No: follow the standard. Saves go in `Documents/My Games/<Game>`; game edits in `Documents/Vibecode3D/Data/Games/levels` (etc.). For now everything stays local to the app; settled in the LIB_PUBLIC release pass |

Note (owner, 18 Nov, on NEXT.md): "stand alone builds don't get the "For Owner" or "Opus" etc
title, because they won't be edited, its "Who is controlling during editing" that becomes an
issue." Done: in a built app `Users.Title` returns just the words given (`Users.IsBuilt`); a form
asked for on purpose (`"FOR"`, `"drive"`) still wins. Tested in t42 (32 pass).

Note (owner, 18 Nov): Haiku, and any other model kept off the save list, may still have its
own output folder, `LIB_LLMOUT/<TAG>/` (for example `LIB_LLMOUT/HAIKU/`), for the text and other
content it produces. The owner or Opus reviews it there and moves what is kept into place.
Not made yet: the folder is created the first time such a model is given work.

## 10. The owner's earlier answers (17 Nov 2026; section 9 of 18 Nov is the latest word)

| # | Answer |
|---|---|
| 2 | **`FOR OWNER`**, not a name: clear, and safe in screenshots. So `current.txt` holds the role only and no real name is needed anywhere (a stranger's PC still shows `FOR PLAYER` or their PC user name: to decide when built). |
| 3 | The bar is fine: `Opus | Theme_Studio`, `FOR OWNER | <what to do first>`. |
| 4 | Claude models (Fable, Opus, Sonnet, Haiku) may save stacks: "for our use absolutely". Spark still drafts only, until its OXT-Beyond use is tested. (18 Nov: Haiku taken off the save list for now; see section 9 #4.) |
| 5 | `VIBE` is the label of the V: drive: a plain simulated C: for testing a real Vibecode3D / xt3d install, plus the owner's apps for Claude (OXT-Beyond) and documents kept out of git. Not a user. `Vibe/About_vibe.txt` stays as it is. |
| 1, 6 | still open (defaults stand). |
