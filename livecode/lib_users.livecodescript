script "LIB_USERS"
-- LIB_USERS: who is at the controls of a window, and the one wording of window titles.
-- LIB_ALPHA rules 13 and 14, PLAN.md section 4 ("The title, decided once").
--
--   start using stack "<path>/LIB_USERS/livecode/lib_users.livecodescript"
--   Users.Take "OPUS"                                  -- an AI takes the controls
--   put Users.Title("Theme_Studio") into tT            -- "Opus | Theme_Studio"
--   Users.HandTo                                       -- back to the person at this machine
--   put Users.Title("Press Space to start, H for help") into tT
--                                                      -- "FOR OWNER | Press Space to start, H for help"
--   Users.TitleStack "Theme_Studio", "pick a colour, press Save"   -- sets the TITLE, never the name
--
-- Handlers: Users.Title, Users.TitleStack, Users.Driver, Users.Take, Users.HandTo,
-- Users.Current, Users.SetCurrent, Users.IsPerson.
--
-- This is the small first piece (the titles). Not here yet, see PLAN.md section 6:
-- users.tsv and Users.Load / List, current.txt in the Data folder (so SetCurrent is in memory
-- only for now), Users.Stamp / Log, Users.May, the long "address" title style.
-- No real names in this file: the person at this machine is "OWNER" until told otherwise.

global gUsersDriver   -- who has the controls now (a tag: OPUS, FABLE ...); empty = the person
local sCurrentTag     -- the person's role at this machine (OWNER, PLAYER ...)
local sCurrentName    -- the name shown in "FOR <name>" titles

constant kPersonTags = "OWNER,PLAYER"

-- the person at this machine (the name shown in FOR titles)
function Users.Current
   if sCurrentName is empty then
      return "OWNER"
   end if
   return sCurrentName
end Users.Current

-- in memory only for now; later it writes Data/Users/current.txt
command Users.SetCurrent pTag, pName
   put toUpper(pTag) into sCurrentTag
   if pName is empty then
      put sCurrentTag into sCurrentName
   else
      put toUpper(pName) into sCurrentName
   end if
end Users.SetCurrent

-- who has the controls now: the taken tag, else $XT_USER (a headless run started by an AI),
-- else the person at this machine
function Users.Driver
   if gUsersDriver is not empty then
      return gUsersDriver
   end if
   if $XT_USER is not empty then
      return toUpper($XT_USER)
   end if
   return Users.Current()
end Users.Driver

command Users.Take pTag
   put toUpper(pTag) into gUsersDriver
end Users.Take

-- give the controls back; with no tag, to the person at this machine
command Users.HandTo pTag
   if pTag is empty then
      put Users.Current() into gUsersDriver
   else
      put toUpper(pTag) into gUsersDriver
   end if
end Users.HandTo

-- true when pWho is a person (gets "FOR" titles), false for an AI or other agent
function Users.IsPerson pWho
   put toUpper(pWho) into pWho
   if pWho is among the items of kPersonTags then
      return true
   end if
   if pWho is Users.Current() then
      return true
   end if
   if pWho is sCurrentTag and sCurrentTag is not empty then
      return true
   end if
   return false
end Users.IsPerson

-- the title text. pForm empty = by who drives; "FOR" = a window for the person to try;
-- "drive" = the driver's own window
function Users.Title pWhat, pForm
   local tForm, tWho, tHead
   put pForm into tForm
   if tForm is empty then
      if Users.IsPerson(Users.Driver()) then
         put "FOR" into tForm
      else
         put "drive" into tForm
      end if
   end if
   if tForm is "FOR" then
      put "FOR" && Users.Current() into tHead
   else
      put Users.Driver() into tWho
      put toUpper(char 1 of tWho) & toLower(char 2 to -1 of tWho) into tHead
   end if
   if pWhat is empty then
      return tHead
   end if
   return tHead && "|" && pWhat
end Users.Title

-- sets the title (never the name) of stack pStack; pWhat empty = the stack's short name.
-- The result is empty, or why not.
command Users.TitleStack pStack, pWhat, pForm
   local tWhat
   if there is not a stack pStack then
      return "no stack" && pStack
   end if
   put pWhat into tWhat
   if tWhat is empty then
      put the short name of stack pStack into tWhat
   end if
   set the title of stack pStack to Users.Title(tWhat, pForm)
   return empty
end Users.TitleStack
