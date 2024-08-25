### Requires AutoHotkey
This is an AutoHotkey script, make sure you have the program autohotkey installed. https://www.autohotkey.com/

# Virtual Clipboard
The VirtualClipboard script creates a skeuomorphic virtual clipboard for storing saved text clippings. 
It works by automatically saving (Ctrl + C) & (Ctrl + X) keyboard actions to a list, 
and selecting a list items saves that stored text to your clipboard to be used in paste.

![Demo](/VirtualClipboard.gif)

Setup:
This full repo containing an Assets folder, and the VirtualClipboard.ahk file should be saved to your local machine.
Open the .ahk file and set the following lines to this file location you just made, this should be the location containing the script file and assets folder.

(This should be done in your script document, below is for reference only)
; TO BEGIN: This script requres you to set the directory that the script is located, this location must also contain the Assets folder
SetWorkingDir, C:\...\VirtualClipboard

This can now be run using right click > "Run Script" or by adding it your main AutoHotkey script using the following format:

(You can set your own HotKey modifiers, I used Ctrl + Alt + C)
;Create a virtual clipboard to save something - Ctrl, Alt, C
^!c::Run C:\...\VirtualClipboard\VirtualClipboard.ahk

The above should be the direct file path to the script file you made on your local machine.
