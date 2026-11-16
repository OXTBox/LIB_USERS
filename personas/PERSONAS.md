# Personas: the people who will install Vibecode3D

Made 2026-11-15 from the owner's request: "simulate how people in the real world try to escape
it and the operating system issues they encounter". Each one is a habit or a machine quirk that
real players have, not a real person. `personas.tsv` is the machine-readable list.
`LIB_PUBLIC/install/escape_sim.py` gives each one a profile on the simulated drive
(`V:\Users\<username>\`) and plays out their habits against the install.

| Who | The PC | What they do | What it tests |
|---|---|---|---|
| **Dana** | everything default | takes every default | the baseline: if Dana has trouble, everyone does |
| **Ana Lucía Peña** | user folder `C:\Users\Ana Lucía Peña` | backs up her saves by hand | accents and spaces in every path we write |
| **健二 (Kenji)** | user folder in kanji, code page 932 | starts games from their own `.cmd` | Unicode paths through `cmd.exe` and file URLs |
| **Morgan** | OneDrive moved Documents | backs up saves, syncs two PCs | the Data folder inside OneDrive: placeholders, `save-PC2.txt` conflicts |
| **Sam** | not admin; a USB stick | carries the games, the drive letter changes | portable mode, absolute paths, FAT32 limits |
| **Riley** | small SSD | drags the library to D: | moved folders, stale appmanifests |
| **Jordan** | school PC, not admin | runs from the zip | Program Files read-only, Defender's Controlled Folder Access on Documents |
| **Pat** | hates launchers | uninstalls the store, keeps the games | does a game folder stand alone? |
| **Alex** | modder | edits scripts in place, then "verify files" | mods lost on repair; a mods folder instead |
| **Chris** | weekly cleaner app | AppData and Temp wiped | settings in AppData are disposable; saves must not be there |
| **Lee** | family PC, two accounts | the second account starts the game | per-user vs per-machine files |
| **Taylor** | downloads the zip | double-clicks the exe inside it; copies the exe to the Desktop | Mark of the Web, SmartScreen, the exe without its folder |

The owner's own profile (`V:\AppData`, `V:\Documents`, made by the owner) is the default when no
persona is named.
