# LIB_USERS: where it stands

Tuesday, November 17, 2026 (branch `users-title`, made from `library-plans`).

## Done

- `livecode/lib_users.livecodescript`, the first small piece of PLAN.md:
  - `Users.Title(pWhat, pForm)`: `FOR OWNER | <what>` when a person drives, `Opus | <what>`
    when an AI drives (short name, mixed case). pForm `"FOR"` or `"drive"` forces one form.
  - `Users.TitleStack pStack, pWhat, pForm`: sets the stack's title, never its name; empty
    pWhat uses the stack's name; the result says so when there is no such stack.
  - The tiny "who drives now" state: `Users.Take`, `Users.HandTo`, `Users.Driver`
    (global `gUsersDriver`, else `$XT_USER`, else the person), `Users.Current`,
    `Users.SetCurrent` (in memory only), `Users.IsPerson`.
- Test: OXT-BEYOND/tests/t42_users_title.txt, 21 checks, all pass headless.
- TITLES_TO_MOVE.md: the ten scripts that still word their titles by hand, and ten more
  windows with no "who" in the title.

## Next

1. (done 17 Nov) The ten scripts in TITLES_TO_MOVE.md ask `Users.TitleStack` through
   `dispatch`, falling back to `FOR OWNER | ...` (board_canvas left as is: its title is data and
   already FOR OWNER). Branches: LIB_DEV on-git-or-not; users-title in LIB_BUILD,
   LIB_SCRIPTBLOCKS, LIB_TTRPG, LIB_RTS, LIB_BIT.
2. PLAN.md step 1 properly: `users.tsv`, `Users.Load` / `Users.List`, and `current.txt` in the
   Data folder (through LIB_DATA), so `Users.SetCurrent` is remembered and the roster, not a
   built-in list, says who is a person.
3. `Users.Stamp` / `Users.Log`, then `Users.May`.
4. The long title style (`127.0.0.1:8769 | Opus | ...`) only if the owner asks for it.

## For the owner to decide

- Until `current.txt` exists, the person at the machine shows as `FOR OWNER`. The plan's
  default is your own name from the Data folder on your machine; say which you want.
- Whether windows with no "who" today (game windows, the launcher, servers) should get one.
- LIB_ALPHA rules 13 and 14 still give the old long wording; the plan suggests they say "ask
  `Users.Title`". Not changed here.
