forged-alliance-template-synchronizer
=====================================

A standalone Supreme Commander: Forged Alliance template synchronization utility, written in Lua 5.2.

Special thanks
--------------

Special thanks to Niquest for his help developing the exclusion list, tech level override list, and special case information.

Basic Installation (Windows)
----------------------------

- Locate your Game.prefs file. To do this, open My Computer and paste the one of the following into the address bar at the top:
    - Windows XP: %USERPROFILE%\Local Settings\Application Data\Gas Powered Games\Supreme Commander Forged Alliance
    - Windows Vista/7: %USERPROFILE%\AppData\Local\Gas Powered Games\Supreme Commander Forged Alliance
- Download the right Lua executable from [http://luabinaries.sourceforge.net/](LuaBinaries) - if in doubt, grab the Windows x86 Executables.
- Unzip the file you just downloaded to the folder that contains Game.prefs.
- Download the files in this repostory. Place them in the same folder as Game.prefs.
- Back up your existing Game.prefs file! Copying it to your desktop is always a safe bet.
- Extract the zip file you downloaded with your Lua binaries to the same folder as your Game.prefs file.
- Create a shortcut to your Lua executable (such as lua52.exe). To do this, right-click on the Lua executable and click on Create Shortcut.
- Modify the shortcut you just created. Right-click on it, click on Properties, and find the text field labeled "Target". Add "synchronize.lua" (in quotes) to the end of this field. It should say something like: "C:\Users\YourUserName\AppData\Local\Gas Powered Games\Supreme Commander Forged Alliance\lua52.exe" "synchronize.lua"
- Close the Properties window by clicking OK.
- Consider copying/moving the shortcut to your desktop for convenience.
- Done! Now you can run the utility!

First Run
---------

If you run the utility and you're overwhelmed by the number of templates each faction has, don't panic! Clean up one and _only one_ faction's templates - get it exactly how you want it. Then close the game and re-run the synchronizer. Voila! All four factions should be cleaned up!

Command-Line Options
--------------------

synchronize.lua [-f filename] [-b filename]

-f filename Specifies a file to operate on. The default is Game.prefs in the current folder.  
-b filename Specifies a backup file to use. The default is old.Game.prefs in the current folder.

Under the Hood
--------------

Basically, the synchronizer checks how many copies you have of a template. If you have 1 or 2 copies (meaning 1 or 2 factions have the template), it synchronizes the template across all 4. If you have 3 copies, _the script assumes you deleted the fourth_, so it removes the existing 3 copies. This makes renaming and deleting templates work, and it also explains why you should only clean up one faction's templates when you first launch!

There's a list of excluded structures. Anything that has no reasonable equivalent for any other faction (i.e. the Mavor) is on this list. If a template has an excluded structure, it won't be synced - but it'll stick around unless you delete it.

Special Cases
-------------

As experienced Forged Alliance players know, there are unique aspects to each faction's build tree. For instance, Cybran commanders can't build Tier 3 shield generators. The synchronizer does its best to make intelligent decisions about these special cases. The following is theoretically a complete list of special cases, but see the source if you want the definitive list.

- Cybran and UEF engineering stations. Templates that have engineering stations will convert them appropriately to Cybran and UEF ones (for Cybran and UEF templates) and simply won't include these structures in Aeon and Seraphim templates.
- Shields. When creating Cybran equivalents to templates with T3 shields, T2 shield generators will be used instead.
  When creating Aeon, UEF, and Seraphim equivalents for a Cybran template with shield generators, T3 shield generators will be used if and only if the source template has other T3 structures in it. Otherwise, T2 shield generators are used.
- T3 point defense. When creating equivalents to UEF templates with T3 point defense, T2 point defense is substituted.
  When creating UEF equivalents to Aeon, Cybran, or Seraphim templates with T2 point defense, UEF T3 point defense will be used if and only if the source template has other T3 structures in it. Otherwise, T2 point defense is used.


Known Limitations
-----------------

As of this writing (the initial commit), the synchronizer uses template names to identify templates. So if you delete and recreate a template (presumably to make modifications to it), the synchronizer won't see any changes. Because of this same mechanic, the behavior of this script is unspecified if you have more than one template with the same name belonging to the same faction. In other words, _don't give two templates for the same faction the same name!_

Downloaded units are unlikely to work properly with this script. The assumptions the script necessarily makes about unit ID formats will likely cause it to mangle downloaded units.

Possible Enhancements
---------------------

- Folder organization. If there's a way to put tests in a test folder and source files in an src folder (and still have dofile() work), I'll gladly do it! If you know a way, let me know! :)
- Better template identity. It was dramatically simpler to initially use template names for identifying templates, but a more thorough identification process would be a huge improvement. It would even allow for templates to be updated without fiddling with names!
- User-specified exclusion lists for templates. It might be useful to have specialized Aeon templates to account for funky TMD positioning. There are probably lots of other cases, too. There's no way to exclude a template from sync except to put an excluded unit, and rectifying that would be good for power users.
- User-specified overrides to the special cases. I'm not sure how this would even work, short of giving users a way to write their own special case handlers in Lua, but it would be cool. Maybe a user doesn't want UEF T3 templates to use Heavy Point Defense instead of T2 Point Defense.
- Working properly with DLC units. The way the script understands unit IDs makes processing Forged Alliance data much simpler at the cost of compatibility with DLC.

License and Copyright
---------------------

Copyright 2012 Dylan Laufenberg. This software is released under the terms of the MIT License as stated in the included file named "LICENSE".
