#!/usr/bin/env osascript
on run argv
tell application "System Events"
    if (item 1 of argv exists) then
        keystroke "\\" using control down
        keystroke "n" using control down
        keystroke item 1 of argv & item 2 of argv
        keystroke "j" using control down
    end if
end tell
end run



